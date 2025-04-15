module dadda_multiplier (a,b,p);
 input[7:0] a,b;
 output [15:0] p;
 wire[15:0] pp[7:0][7:0];
 wire [1:58] t;
 wire [1:56] cy;
 integer i,j;
 
 genvar gi, gj;
 generate
   for(gi=0; gi<8; gi=gi+1) begin : gen_pp_i
     for(gj=0; gj<8; gj=gj+1) begin : gen_pp_j
       assign pp[gi][gj] = b[gi] & a[gj];
     end
   end
 endgenerate
 
 //stage 1 reduction - 6 values
 assign {cy[1], t[1]} = pp[0][6] + pp[1][5];
 assign {cy[2], t[2]} = pp[0][7] + pp[1][6] + pp[2][5];
 assign {cy[3], t[3]} = pp[3][4] + pp[4][3];
 assign {cy[4], t[4]} = pp[1][7] + pp[2][6] + pp[3][5];
 assign {cy[5], t[5]} = pp[4][4] + pp[5][3];
 assign {cy[6], t[6]} = pp[2][7] + pp[3][6] + pp[4][5];
 
 //stage 2 reduction - 4 values
 assign {cy[7], t[7]} = pp[0][4] + pp[1][3];
 assign {cy[8], t[8]} = pp[0][5] + pp[1][4] + pp[2][3];
 assign {cy[9] ,t[9]} = pp[3][2] + pp[4][1];
 assign {cy[10], t[10]} = t[1] + pp[2][4] + pp[3][3];
 assign {cy[11], t[11]} = pp[4][2] + pp[5][1] + pp[6][0];
 assign {cy[12], t[12]} = cy[1] + t[2] + t[3];
 assign {cy[13], t[13]} = pp[5][2] + pp[6][1] + pp[7][0];
 assign {cy[14], t[14]} = cy[2] + cy[3] + t[4];
 assign {cy[15], t[15]} = t[5] + pp[6][2] + pp[7][1];
 assign {cy[16], t[16]} = cy[4] + cy[5] + t[6];
 assign {cy[17], t[17]} = pp[5][4] + pp[6][3] + pp[7][2];
 assign {cy[18], t[18]} = cy[6] + pp[3][7] + pp[4][6];
 assign {cy[19], t[19]} = pp[5][5] + pp[6][4] + pp[7][3];
 assign {cy[20], t[20]} = pp[4][7] + pp[5][6] + pp[6][5];
 
 //stage 3 reuduction - 3
 assign {cy[21], t[21]} = pp[0][3] + pp[1][2];
 assign {cy[22], t[22]} = t[7] + pp[2][2] + pp[3][1];
 assign {cy[23], t[23]} = cy[7] + t[8] + t[9];
 assign {cy[24], t[24]} = cy[8] + cy[9] + t[10];
 assign {cy[25], t[25]} = cy[10] + cy[11] + t[12]; 
 assign {cy[26], t[26]} = cy[12] + cy[13] + t[14];
 assign {cy[27], t[27]} = cy[14] + cy[15] + t[16];
 assign {cy[28], t[28]} = cy[16] + cy[17] + t[18];
 assign {cy[29], t[29]} = cy[18] + cy[19] + t[20];
 assign {cy[30], t[30]} = cy[20] + pp[5][7] + pp[6][6];
 
 //stage 4 reduction - 2
 assign {cy[31], t[31]} = pp[0][2] + pp[1][1];
 assign {cy[32], t[32]} = t[21] + pp[2][1] + pp[3][0];
 assign {cy[33], t[33]} = cy[21] + t[22] + pp[4][0];
 assign {cy[34], t[34]} = cy[22] + t[23] + pp[5][0]; 
 assign {cy[35], t[35]} = cy[23] + t[24] + t[11];
 assign {cy[36], t[36]} = cy[24] + t[25] + t[13];
 assign {cy[37], t[37]} = cy[25] + t[26] + t[15];
 assign {cy[38], t[38]} = cy[26] + t[27] + t[17];
 assign {cy[39], t[39]} = cy[27] + t[28] + t[19];
 assign {cy[40], t[40]} = cy[28] + t[29] + pp[7][4];
 assign {cy[41], t[41]} = cy[29] + t[30] + pp[7][5];
 assign {cy[42], t[42]} = cy[30] + pp[6][7] + pp[7][6];
  
 //final stage
 assign t[43]=pp[0][0];
 assign {cy[43], t[44]} = pp[0][1] + pp[1][0];
 assign {cy[44], t[45]} = t[31] + pp[2][0] + cy[43];
 assign {cy[45], t[46]} = cy[31] + t[32] + cy[44];
 assign {cy[46], t[47]} = cy[32] + t[33] + cy[45];
 assign {cy[47], t[48]} = cy[33] + t[34] + cy[46];
 assign {cy[48], t[49]} = cy[34] + t[35] + cy[47];
 assign {cy[49], t[50]} = cy[35] + t[36] + cy[48];
 assign {cy[50], t[51]} = cy[36] + t[37] + cy[49];
 assign {cy[51], t[52]} = cy[37] + t[38] + cy[50];
 assign {cy[52], t[53]} = cy[38] + t[39] + cy[51];
 assign {cy[53], t[54]} = cy[39] + t[40] + cy[52];
 assign {cy[54], t[55]} = cy[40] + t[41] + cy[53];
 assign {cy[55], t[56]} = cy[41] + t[42] + cy[54];
 assign {cy[56], t[57]} = cy[42] + pp[7][7] + cy[55];
 assign t[58]=cy[56];
 assign p = {t[58],t[57],t[56],t[55],t[54],t[53],t[52],t[51],t[50],t[49],t[48],t[47],t[46],t[45],t[44],t[43]};

endmodule
