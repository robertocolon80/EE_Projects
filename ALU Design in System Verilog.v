
module mux21_4bit(A,B,S,F);

input [3:0] A,B;
input S;
output [3:0] F;

mux21 m0(A[0],B[0],S,F[0]);
mux21 m1(A[1],B[1],S,F[1]);
mux21 m2(A[2],B[2],S,F[2]);
mux21 m3(A[3],B[3],S,F[3]);

endmodule

module ALU_8b(CarryOut, ALU_Out, ALU_Sel, A, B);

input [7:0] A,B;
input [3:0] ALU_Sel;
input [7:0] ALU_Out;
output CarryOut;

reg [7:0] ALU_Result;
    wire [8:0] tmp;
    assign ALU_Out = ALU_Result; // ALU out
    assign tmp = {1'b0,A} + {1'b0,B};
    assign CarryOut = tmp[8]; // Carryout flag
    always @(*)

    begin
        case(ALU_Sel)
        4'b0000: // Add
           ALU_Result = A + B ; 
        4'b0001: // Subtract
           ALU_Result = A - B ;
        4'b0010: // Multiply
           ALU_Result = A * B;
        4'b0011: // Divide
           ALU_Result = A/B;
        4'b0100: // Logical shift left
           ALU_Result = A<<1;
         4'b0101: // Logical shift right
           ALU_Result = A>>1;
         4'b0110: // Rotate left
           ALU_Result = {A[6:0],A[7]};
         4'b0111: // Rotate right
           ALU_Result = {A[0],A[7:1]};
          4'b1000: //  Logical AND 
           ALU_Result = A & B;
          4'b1001: //  Logical OR
           ALU_Result = A | B;
          4'b1010: //  Logical XOR 
           ALU_Result = A ^ B;
          4'b1011: //  Logical NOR
           ALU_Result = ~(A | B);
          4'b1100: // Logical NAND 
           ALU_Result = ~(A & B);
          4'b1101: // Logical XNOR
           ALU_Result = ~(A ^ B);
          4'b1110: // Greater comparison
           ALU_Result = (A>B)?8'd1:8'd0 ;
          4'b1111: // Equal comparison   
            ALU_Result = (A==B)?8'd1:8'd0 ;
          default: ALU_Result = A + B ; 
        endcase
    end

endmodule

module Compare_4b1(GT, LT, A, B);

input [3:0] A,B;
output GT,LT;

always @(A or B)
    begin 
        if(A>B)
            GT=1, LT=0;
        else if(A<B)
            GT=0, LT=1;
        else
            GT=0, LT=0
    end
endmodule

module Compare_4b2(GT,LT,A,B);

input [7:4] A,B;
output GT,LT;

always @(A or B)
    begin
        if(A>B)
            GT=1, LT=0;
        else if(A<B)
            GT=0, LT=1;
        else
            GT=0, LT=0;
    end
endmodule

module Equality_8b(Equal,A,B);

input [7:0] A,B;
output Equal;

wire w0,w1,w2,w3,w4,w5,w6,w7,wA,wB;

begin
    xnor u0(w0,A[0],B[0]);
    xnor u1(w1,A[1],B[1]);
    xnor u2(w2,A[2],B[2]);
    xnor u3(w3,A[3],B[3]);
    xnor u4(w4,A[4],B[4]);
    xnor u5(w5,A[5],B[5]);
    xnor u6(w6,A[6],B[6]);
    xnor u7(w7,A[7],B[7]);
    nand ua(wA,w0,w1,w2,w3);
    nand ub(wB,w4,w5,w6,w7);
    nor(Equal,wA,wB);
end

endmodule


module Mux8To1(Out,Sel,In)