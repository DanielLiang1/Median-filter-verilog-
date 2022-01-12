`define ROW 1080
`define COL 1920

`define width 8

`define SIZES_BIT `ROW*`COL*`width*4
`define ROW_STEP `COL*`width*4
`define VALUE_WIDTH_VALID `width*3
`define VALUE_WIDTH `width*4

// 3840_h2160
`define IN_FILE_NAME  "bayer_24bit.raw"
`define OUT_FILE_NAME "bayer_24bit_f.raw"
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
module test_read_write;
// -----------------------------------------------------------------------------
// ----------------------------test arguments-----------------------------------
reg		      [0:31]	 r32;	   // printing reg
reg		      [0:23]	 r24;	   // printing reg
reg              [0: `SIZES_BIT - 1] data_in;	   // all data  size = ROW * COL * 24 - 1
reg      [`ROW_STEP-1:0]data_out;	   // line out from module
integer   file_in, file_out, i, j, f;	   // file pointer's, loop index's
// -----------------------------------------------------------------------------
// --------------------------component arguments--------------------------------
reg      [`ROW_STEP-1:0]  row_in;
// reg         	CLK ;
// reg				SET ;
// reg				RST ;
// wire     [`ROW_STEP-1:0] row_out;
// // -----------------------------------------------------------------------------
// // ---------------------------------UUT-----------------------------------------
// // dirtylena UUT(
// NSCLR UUT(
// .row_in		(row_in),
// .CLK		   (CLK),
// .SET 		   (SET),
// .RST 		   (RST),
// .row_out       (row_out)
// );
// // -----------------------------------------------------------------------------
// // ----------------------------Clock Generator----------------------------------
// always 
// begin 
// CLK = 0; 
// #5; 
// CLK = 1; 
// #5; 
// end  
// -----------------------------------------------------------------------------
// ---------------------------start simulation----------------------------------
initial begin
file_in  = $fopen(`IN_FILE_NAME,"rb");
file_out = $fopen(`OUT_FILE_NAME,"wb");
f = $fread(data_in , file_in);
// SET = 1'b0;			//first row in with the commend SET//
// row_in = data_in[0:`ROW_STEP-1];     // `ROW*`width*3-1
// RST = 1'b1;
// #5;
// SET = 1'b1;
// // -----------------------------------------------------------------------------
// // row_in = data_in[6144:12287];	//second row
// row_in = data_in[`ROW_STEP:`ROW_STEP*2-1];	//second row
// RST = 1'b1;
// SET = 1'b1;
// -----------------------------------------------------------------------------
// 64 起始地址  32 数据位宽
// [0, 0]: 2761761, 33, 36, 42
// [0, 2]: 2695967, 31, 35, 41
// [0, 4]: 2630688, 32, 36, 40

// r32 = data_in[0 +:32];
// $display("%d, %d,%d, %d",r32,r32[0:7],r32[8:15],r32[16:23]);
// r24 = data_in[0 +:24];  // r24 = r24[0:7] <<16 + r24[8:15] << 8 + r24[16:23]
// $display("%d, %d,%d, %d",r24,r24[0:7],r24[8:15],r24[16:23]);
// r24 = data_in[32 +:24];  // r24 = r24[0:7] <<16 + r24[8:15] << 8 + r24[16:23]
// $display("%d, %d,%d, %d",r24,r24[0:7],r24[8:15],r24[16:23]);
// r24 = data_in[64 +:24];  // r24 = r24[0:7] <<16 + r24[8:15] << 8 + r24[16:23]
// $display("%d, %d,%d, %d",r24,r24[0:7],r24[8:15],r24[16:23]);

for ( i=0 ; i<`ROW ; i=i+1 )    //all other rows
begin
	
// 	// SET =  1'b1;
// 	// row_in = data_in[12288+6144*i +:6144];
	row_in = data_in[`ROW_STEP*i +:`ROW_STEP];

    // $display("%d, %d",`ROW_STEP*i,`ROW_STEP);
    // r24 = row_in[8 +:24];  // r24 = r24[0:7] <<16 + r24[8:15] << 8 + r24[16:23]
    // $display("%d, %d,%d, %d",r24,r24[0:7],r24[8:15],r24[16:23]);

// 	// RST =  1'b1; 
	// data_out = row_out;   
	for (j=0 ; j<`COL ; j=j+1) 
		begin
			// r24 = data_out[6120-24*j +:24];
			r24 = row_in[`VALUE_WIDTH -`VALUE_WIDTH_VALID +`VALUE_WIDTH*j +:`VALUE_WIDTH_VALID];

			// $display("%d, %d,%d, %d",r24,r24[0:7],r24[8:15],r24[16:23]);
			$fwrite(file_out, "%c%c%c" ,r24[0:7],r24[8:15],r24[16:23]);
		end
	#10;
end
// -----------------------------------------------------------------------------
$fclose(file_in);
$fclose(file_out);
// $stop;
$finish;
end
endmodule
// -------------------------------End-------------------------------------------		
