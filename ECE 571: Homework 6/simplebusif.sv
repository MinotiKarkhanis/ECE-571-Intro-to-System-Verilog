interface main_bus(input logic resetN, clock);
  logic start;
  logic  read;
  wire dataValid;
  logic [7:0]address;
  wire [7:0]data;

  modport proc( 
    input resetN, 
    input clock,
    output start, 
    output read,
    inout dataValid,
    output address,
    inout data
  );

  modport mem (
    input resetN, 
    input clock,
    input start, 
    input read,
    inout dataValid,
    input address,
    inout data
  );

endinterface

module top;

  logic clock = 1;
  logic resetN = 0;

  always #5 clock = ~clock;

  initial #2 resetN = 1;
  parameter InterfaceThreads=90;

  main_bus bus(.*);
  ProcessorIntThread PT(.pins(bus.proc));

  generate
    genvar i;
    for(i=0;i<InterfaceThreads;i++)
      begin
        MemoryIntThread #(i) MT(.pins(bus.mem));
      end
  endgenerate
endmodule

module ProcessorIntThread(interface pins);

  logic en_AddrUp, en_AddrLo, ld_Data, en_Data, access = 0 ,en_MemoryAddr;
  logic doRead, wDataRdy, dv;
  logic [7:0] DataReg;
  logic [23:0] AddrReg;

  enum {MA,Mnew,MB,MC,MD} State, NextState;

  assign pins.data = (en_Data) ? DataReg : 'bz;
  assign pins.dataValid = (State == MD) ? dv : 1'bz;

  always_comb
    if (en_AddrLo) pins.address = AddrReg[7:0];
  else if (en_AddrUp) pins.address = AddrReg[15:8];
  else if (en_MemoryAddr) pins.address=AddrReg[23:16];
  else pins.address = 'bz;

  always_ff @(posedge pins.clock)
    if (ld_Data) DataReg <= pins.data;

  always_ff @(posedge pins.clock, negedge pins.resetN)
    if (!pins.resetN) State <= MA;
  else State <= NextState;


  always_comb
    begin
      pins.start = 0;
      en_AddrUp = 0;
      en_AddrLo = 0;
      en_MemoryAddr=0;
      pins.read = 0;
      ld_Data = 0;
      en_Data = 0;
      dv = 0;

      case(State)
        MA:	begin
          NextState = (access) ? Mnew : MA;
          pins.start = (access) ? 1 : 0;
          en_MemoryAddr=(access)? 1 : 0;
        end

        Mnew: begin
          NextState= MB;
          en_AddrUp=1;
        end

        MB:	begin
          NextState = (doRead) ? MC : MD;
          en_AddrLo = 1;
          pins.read = (doRead) ? 1 : 0;
        end
        MC:	begin
          NextState = (pins.dataValid) ? MA : MC;
          ld_Data = (pins.dataValid) ? 1 : 0;
        end
        MD:	begin
          NextState = (wDataRdy) ? MA : MD;
          en_Data = (wDataRdy) ? 1 : 0;
          dv = (wDataRdy) ? 1 : 0;
        end
      endcase
    end

  task WriteMem(input [23:0] Avalue, input [7:0] Dvalue);   
    begin
      access <= 1;
      doRead <= 0;
      wDataRdy <= 1;
      AddrReg <= Avalue;
      DataReg <= Dvalue;
      @(posedge pins.clock) access <= 0;
      @(posedge pins.clock);
      wait (State == MA); 
      repeat (2) @(posedge pins.clock);
    end
  endtask


  task ReadMem(input [23:0] Avalue);   
    begin
      access <= 1;
      doRead <= 1;
      wDataRdy <= 0;
      AddrReg <= Avalue;
      @(posedge pins.clock) access <= 0;
      @(posedge pins.clock);
      wait (State == MA); 
      repeat (2) @(posedge pins.clock);
    end
  endtask


  initial
    begin
      repeat (2) @(posedge pins.clock);
      // Note this is from the textbook but is *not* a good test!!
      WriteMem(24'h200406, 8'hDC);
      ReadMem(24'h200406);
      WriteMem(24'h150407, 8'hAB);
      ReadMem(24'h150406);
      WriteMem(24'h250407, 8'hCD);
      ReadMem(24'h250407);
      WriteMem(24'h050407, 8'hAA);
      ReadMem(24'h050407);
      WriteMem(24'h100407, 8'hAC);
      ReadMem(24'h100407);
      $finish;
    end

  endmodule



  module MemoryIntThread (interface pins);

    parameter BaseAddress=8'h00;    
    logic [7:0] Mem[16'hFFFF:0], MemData;
    logic ld_AddrUp, ld_AddrLo, memDataAvail = 0;
    logic en_Data, ld_Data, dv;
    logic [7:0] DataReg;
    logic [15:0] AddrReg;
    logic Addr_same;


    enum {SA,Snew, SB, SC, SD} State, NextState;


    initial
      begin
        for (int i = 0; i < 16'hFFFF; i++)
          Mem[i] <= 0;
      end

    assign Addr_same =(pins.address==BaseAddress);  
    assign pins.data = (en_Data) ? MemData : 'bz;
    assign pins.dataValid = (State == SC) ? dv : 1'bz;


    always @(AddrReg, ld_Data)
      MemData = Mem[AddrReg];

    always_ff @(posedge pins.clock)
      if (ld_AddrUp) AddrReg[15:8] <= pins.address;

    always_ff @(posedge pins.clock)
      if (ld_AddrLo) AddrReg[7:0] <= pins.address;


    always @(posedge pins.clock)
      begin
        if (ld_Data)
          begin
            DataReg <= pins.data;
            Mem[AddrReg] <= pins.data;
          end
      end

    always_ff @(posedge pins.clock, negedge pins.resetN)
      if (!pins.resetN) State <= SA;
    else State <= NextState;


    always_comb
      begin
        ld_AddrUp = 0;
        ld_AddrLo = 0;
        dv = 0;
        en_Data = 0;
        ld_Data = 0;

        case (State)
          SA: begin
            NextState = (pins.start & Addr_same) ? Snew : SA;
          end

          Snew: begin 
            NextState=SB;
            ld_AddrUp=1;
          end

          SB: begin
            NextState = (pins.read) ? SC : SD;
            ld_AddrLo =  1;
          end

          SC: begin
            NextState = (memDataAvail) ? SA : SC;
            dv = (memDataAvail) ? 1 : 0;
            en_Data = (memDataAvail) ? 1 : 0;
          end

          SD: begin
            NextState = (pins.dataValid) ? SA: SD;
            ld_Data = (pins.dataValid) ? 1 : 0;
          end
        endcase
      end

    // *** testbench code
    always @(State)
      begin
        bit [2:0] delay;
        memDataAvail <= 0;
        if (State == SC)
          begin
            delay = $random;
            repeat (2 + delay)
              @(posedge pins.clock);
            memDataAvail <= 1;
          end
      end

    endmodule







