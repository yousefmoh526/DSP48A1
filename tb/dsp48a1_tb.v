module DSP_48_tb;

    parameter A0REG = 0;          
    parameter A1REG = 1;           
    parameter B0REG = 0;           
    parameter B1REG = 1;           
    parameter CREG = 1;            
    parameter DREG = 1;            
    parameter MREG = 1;            
    parameter PREG = 1;            
    parameter CARRYINREG = 1;      
    parameter CARRYOUTREG = 1;     
    parameter OPMODEREG = 1;       
    parameter CARRYINSEL = "OPMODE5"; 
    parameter B_INPUT = "DIRECT";  

    reg  [17:0] A;        
    reg  [17:0] B;        
    reg  [47:0] C;       
    reg  [17:0] D;        
    reg         CARRYIN;  
    
    wire [35:0] M;        
    wire [47:0] P;        
    wire        CARRYOUT; 
    wire        CARRYOUTF;
    
    reg         CLK;     
    reg  [7:0]  OPMODE;   
    reg         CEA;      
    reg         CEB;      
    reg         CEC;      
    reg         CECARRYIN;
    reg         CED;      
    reg         CEM;      
    reg         CEOPMODE; 
    reg         CEP;      
    
    reg         RSTA;    
    reg         RSTB;     
    reg         RSTC;     
    reg         RSTCARRYIN; 
    reg         RSTD;     
    reg         RSTM;     
    reg         RSTOPMODE;  
    reg         RSTP;     
    
    reg  [17:0] BCIN;     
    wire [17:0] BCOUT;    
    reg  [47:0] PCIN;     
    wire [47:0] PCOUT;

    DSP_48 #(
        .A0REG(A0REG),
        .A1REG(A1REG),
        .B0REG(B0REG),
        .B1REG(B1REG),
        .CREG(CREG),
        .DREG(DREG),
        .MREG(MREG),
        .PREG(PREG),
        .CARRYINREG(CARRYINREG),
        .CARRYOUTREG(CARRYOUTREG),
        .OPMODEREG(OPMODEREG),
        .CARRYINSEL(CARRYINSEL),
        .B_INPUT(B_INPUT)
    ) M1 (
        .A(A),        
        .B(B),        
        .C(C),       
        .D(D),        
        .CARRYIN(CARRYIN),  
        .M(M),        
        .P(P),        
        .CARRYOUT(CARRYOUT), 
        .CARRYOUTF(CARRYOUTF),
        .CLK(CLK),      
        .OPMODE(OPMODE),   
        .CEA(CEA),      
        .CEB(CEB),      
        .CEC(CEC),      
        .CECARRYIN(CECARRYIN),
        .CED(CED),      
        .CEM(CEM),      
        .CEOPMODE(CEOPMODE), 
        .CEP(CEP),      
        .RSTA(RSTA),    
        .RSTB(RSTB),     
        .RSTC(RSTC),     
        .RSTCARRYIN(RSTCARRYIN), 
        .RSTD(RSTD),     
        .RSTM(RSTM),     
        .RSTOPMODE(RSTOPMODE),  
        .RSTP(RSTP),     
        .BCIN(BCIN),     
        .BCOUT(BCOUT),    
        .PCIN(PCIN),     
        .PCOUT(PCOUT)
    );

    
    initial begin
        CLK = 0;
        forever 
            #5 CLK = ~CLK;
    end
    initial begin
        
        A = 0; B = 0; C = 0; D = 0; CARRYIN = 0;
        OPMODE = 0;
        CEA = 0; CEB = 0; CEC = 0; CECARRYIN = 0;
        CED = 0; CEM = 0; CEOPMODE = 0; CEP = 0;
        RSTA = 0; RSTB = 0; RSTC = 0; RSTCARRYIN = 0;
        RSTD = 0; RSTM = 0; RSTOPMODE = 0; RSTP = 0;
        BCIN = 0; PCIN = 0;
        
        RSTA = 1;    
        RSTB = 1;     
        RSTC = 1;     
        RSTCARRYIN = 1; 
        RSTD = 1;     
        RSTM = 1;     
        RSTOPMODE = 1;  
        RSTP = 1;
        
        CEA = $random;
        CEB = $random;
        CEC = $random;
        CED = $random;
        CECARRYIN = $random;
        CEM = $random;
        CEP = $random;
        CEOPMODE = $random;
        OPMODE = $random;
        A = $random;
        B = $random;
        C = $random;
        D = $random;
        PCIN = $random;
        BCIN = $random;
        
        @(negedge CLK);
        
        
        if (M != 0 || P != 0) begin
            $display("Error in reset");
            $display("M = %h, P = %h", M, P);
            $stop;
        end else begin
           
            RSTA = 0;    
            RSTB = 0;     
            RSTC = 0;     
            RSTCARRYIN = 0; 
            RSTD = 0;     
            RSTM = 0;     
            RSTOPMODE = 0;  
            RSTP = 0;
            CEA = 1;
            CEB = 1;
            CEC = 1;
            CED = 1;
            CECARRYIN = 1;
            CEM = 1;
            CEP = 1;
            CEOPMODE = 1;

            
            OPMODE = 8'b11011101; 
            A = 20; B = 10; C = 350; D = 25;
            PCIN = $random;
            BCIN = $random;
            CARRYIN = 0;

            repeat(4) @(negedge CLK);
           
            $display("M=%h, P=%h, CARRYOUT=%b", M, P, CARRYOUT);

            
            OPMODE = 8'b00010000; 
            PCIN = $random;
            BCIN = $random;
            CARRYIN = 0;

            repeat(4) @(negedge CLK);
            
            $display("M=%h, P=%h, CARRYOUT=%b", M, P, CARRYOUT);

            
            OPMODE = 8'b00001010;   
            PCIN = $random;
            BCIN = $random;
            CARRYIN = 0;

            repeat(4) @(negedge CLK);
           
            $display("M=%h, P=%h, CARRYOUT=%b", M, P, CARRYOUT);

            
            OPMODE = 8'b10100111; 
            A = 5; B = 6; C = 350; D = 25; PCIN = 3000;
            BCIN = $random;
            CARRYIN = 0;

            repeat(4) @(negedge CLK);
           
            $display("M=%h, P=%h, CARRYOUT=%b", M, P, CARRYOUT);
        end

        $stop;
    end

endmodule
