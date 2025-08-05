module DSP_48#(
   
    parameter A0REG = 0,           
    parameter A1REG = 1,           
    parameter B0REG = 0,           
    parameter B1REG = 1,           
    parameter CREG = 1,            
    parameter DREG = 1,            
    parameter MREG = 1,            
    parameter PREG = 1,            
    parameter CARRYINREG = 1,      
    parameter CARRYOUTREG = 1,     
    parameter OPMODEREG = 1,       
    parameter CARRYINSEL = "OPMODE5", 
    parameter B_INPUT = "DIRECT",
    parameter RSSTYPE ="SYNC"  
         
) (
    
    input  [17:0] A,        
    input  [17:0] B,        
    input  [47:0] C,       
    input  [17:0] D,        
    input         CARRYIN,  
    
    
    output [35:0] M,        
    output [47:0] P,        
    output        CARRYOUT, 
    output        CARRYOUTF,
    
    
    input         CLK,      
    input  [7:0]  OPMODE,   
    input         CEA,      
    input         CEB,      
    input         CEC,      
    input         CECARRYIN,
    input         CED,      
    input         CEM,      
    input         CEOPMODE, 
    input         CEP,      
    
    input         RSTA,    
    input         RSTB,     
    input         RSTC,     
    input         RSTCARRYIN, 
    input         RSTD,     
    input         RSTM,     
    input         RSTOPMODE,  
    input         RSTP,     
    
    input  [17:0] BCIN,     
    output [17:0] BCOUT,    
    input  [47:0] PCIN,     
    output [47:0] PCOUT     
);

    
    reg [17:0] A0_reg, A1_reg;
    reg [17:0] B0_reg, B1_reg;
    reg [47:0] C_reg;
    reg [17:0] D_reg;
    reg        CARRYIN_reg;
    reg        CARRYOUT_reg;
    reg [7:0]  OPMODE_reg;
    reg [35:0] M_reg;
    reg [47:0] P_reg;

    wire [17:0] A0_wire, A1_wire;
    wire [17:0] B0_wire, B1_wire,B2_wire;
    wire [47:0] C_wire;
    wire [17:0] D_wire;
    wire        CARRYIN_wire;
    wire [7:0]  OPMODE_wire;
    wire [17:0] B_mux_out;
    wire        CARRYIN_mux_out;
    
    wire [17:0] pre_adder_result;
    
    wire [35:0] mult_result;
    wire [35:0] M_wire;
    
    wire [47:0] X_mux_out;
    wire [47:0] Z_mux_out;
    wire [47:0] post_adder_result;
    wire [47:0] P_wire;
    wire        carryout_wire, cyo;
    wire [47:0] DAB_concat;

    
    assign B_mux_out = (B_INPUT=="DIRECT") ? B:BCIN;

    generate
    if(B0REG)
    always @(posedge CLK) begin
        if (RSTB)
            B0_reg <= 18'b0;
        else if (CEB)
            B0_reg <= B_mux_out;
    end
    
    else begin
    always @(posedge CLK or posedge RSTB) begin
        if (RSTB)
            B0_reg <= 18'b0;
        else if (CEB)
            B0_reg <= B_mux_out;
    end
    assign B0_wire = (B0REG == 1) ? B0_reg : B_mux_out;
    end
    endgenerate
   
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTB)
            D_reg <= 18'b0;
        else if (CED)
            D_reg <= D;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTD) begin
        if (RSTD)
            D_reg <= 18'b0;
        else if (CED)
            D_reg <= D;
    end
    end
    endgenerate

    assign D_wire = (DREG == 1) ? D_reg : D;
    
    

    
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTC)
            C_reg <= 18'b0;
        else if (CEC)
            C_reg <= D;
    end
  end
    else begin
    always @(posedge CLK or posedge RSTC) begin
        if (RSTC)
            C_reg <= 18'b0;
        else if (CEC)
            C_reg <= C;
    end
    end
    endgenerate
    assign C_wire = (CREG == 1) ? C_reg : C;

   
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTA)
            A0_reg <= 18'b0;
        else if (CEA)
            A0_reg <= A;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTA) begin
        if (RSTA)
            A0_reg <= 18'b0;
        else if (CEA)
            A0_reg <= A;
    end
    end
    endgenerate
    assign A0_wire = (A0REG == 1) ? A0_reg : A;

   
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTOPMODE)
            OPMODE_reg <= 18'b0;
        else if (CEOPMODE)
            OPMODE_reg <= OPMODE;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTOPMODE) begin
        if (RSTOPMODE)
            OPMODE_reg <= 18'b0;
        else if (CEA)
            OPMODE_reg <= OPMODE;
    end
    end
    endgenerate
    assign OPMODE_wire = (OPMODEREG == 1) ? OPMODE_reg : OPMODE;

    
    assign DAB_concat = {D_wire[11:0], A0_wire, B0_wire};
    assign pre_adder_result = (OPMODE_wire[6] == 0) ? D_wire + B0_wire : D_wire - B0_wire; 
     assign B1_wire = (OPMODE[4] == 0) ? B0_wire : pre_adder_result;
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTB)
            B1_reg <= 18'b0;
        else if (CEB)
            B1_reg <= B1_wire;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTB) begin
        if (RSTB)
            B1_reg <= 18'b0;
        else if (CEA)
            B1_reg <= B1_wire;
    end
    end
    endgenerate
   
assign B2_wire = (B1REG==1) ? B1_reg : B1_wire ;





    assign BCOUT = B2_wire;

    
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTA)
            A1_reg <= 18'b0;
        else if (CEA)
            A1_reg <= A0_wire;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTA) begin
        if (RSTA)
            A1_reg <= 18'b0;
        else if (CEA)
            A1_reg <= A0_wire;
    end
    end
    endgenerate
    assign A1_wire = (A1REG == 1) ? A1_reg : A0_wire;
    
    assign mult_result = A1_wire * B2_wire;
    generate
        if(CARRYINSEL == "OPMODE5")
            assign CARRYIN_mux_out = OPMODE_wire[5];
        else
            assign CARRYIN_mux_out = CARRYIN;
    endgenerate

    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTCARRYIN)
            CARRYIN_reg <= 18'b0;
        else if (CECARRYIN)
            CARRYIN_reg <= CARRYIN_mux_out;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTCARRYIN) begin
        if (RSTCARRYIN)
            CARRYIN_reg <= 18'b0;
        else if (CECARRYIN)
            CARRYIN_reg <= CARRYIN_mux_out;
    end
    end
    endgenerate
    assign CARRYIN_wire = (CARRYINREG == 1) ? CARRYIN_reg : CARRYIN_mux_out;
    
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTM)
            M_reg <= 18'b0;
        else if (CEM)
            M_reg <= mult_result ;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTM) begin
        if (RSTM)
            M_reg <= 18'b0;
        else if (CEM)
            M_reg <= mult_result;
    end
    end
    endgenerate
    assign M_wire = (MREG == 1) ? M_reg : mult_result;

    assign M = M_wire;

    
    assign X_mux_out = (OPMODE_wire[1:0] == 2'b00) ? 48'b0 :
                      (OPMODE_wire[1:0] == 2'b01) ? M_wire :
                      (OPMODE_wire[1:0] == 2'b10) ? P_wire :
                      (OPMODE_wire[1:0] == 2'b11) ? DAB_concat : 48'b0;

    assign Z_mux_out = (OPMODE_wire[3:2] == 2'b00) ? 48'b0 :
                      (OPMODE_wire[3:2] == 2'b01) ? PCIN :
                      (OPMODE_wire[3:2] == 2'b10) ? P_wire :
                      (OPMODE_wire[3:2] == 2'b11) ? C_wire : 48'b0;

    
    assign {cyo, post_adder_result} = (OPMODE_wire[7] == 0) ? 
                                     Z_mux_out + X_mux_out + {47'b0, CARRYIN_wire} : 
                                     Z_mux_out - X_mux_out - {47'b0, CARRYIN_wire};

    
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTP)
            P_reg <= 18'b0;
        else if (CEP)
            P_reg <= post_adder_result ;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTP) begin
        if (RSTP)
            P_reg <= 18'b0;
        else if (CEP)
            P_reg <= post_adder_result;
    end
    end
    endgenerate
    assign P_wire = (PREG == 1) ? P_reg : post_adder_result;

    assign P = P_wire;
    assign PCOUT = P_wire;
    generate
    if(RSSTYPE =="SYNC")begin
    always @(posedge CLK) begin
        if (RSTCARRYIN)
            CARRYOUT_reg <= 18'b0;
        else if (CECARRYIN)
            CARRYOUT_reg <= cyo ;
    end
    end
    else begin
    always @(posedge CLK or posedge RSTM) begin
        if (RSTCARRYIN)
            CARRYOUT_reg <= 18'b0;
        else if (CECARRYIN)
            CARRYOUT_reg <= cyo;
    end
    end
    endgenerate
    assign CARRYOUT_wire = (CARRYOUTREG == 1) ? CARRYOUT_reg : cyo;
    assign CARRYOUT = CARRYOUT_wire;
    assign CARRYOUTF = CARRYOUT_wire;

endmodule
