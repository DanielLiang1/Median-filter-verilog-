// -----------------------------------------------------------------------------
// Verildg course, Holon Institute of Thecnology
// LECTURER             : Dr. Benjamin Abramov
//------------------------------------------------------------------------------
// PROJECT: Median Filter
//------------------------------------------------------------------------------
// FILE NAME            : test_lena.v
// AUTHOR               : Oded yosef
// AUTHOR'S E-MAIL      : odedyosef@Gmail.com
// -----------------------------------------------------------------------------
// RELEASE HISTORY
// VERSION  DATE        AUTHOR        DESCRIPTION
// 1.0      01-09-2018  oded.yosef    Test bench for median filter module
// -----------------------------------------------------------------------------
// KEYWORDS: filter, FSM, median, test bench, file, write, read
// -----------------------------------------------------------------------------
// PURPOSE: Create a median filter for a 256-pixel RGB image.
// -----------------------------------------------------------------------------
`define ROW 256
`define COL 256
`define width 8
`define IN_FILE_NAME  "lena.raw"
`define OUT_FILE_NAME "lena_f.raw"
// -----------------------------------------------------------------------------
// -----------------------------------------------------------------------------
module test_lena;
// -----------------------------------------------------------------------------
// ----------------------------test arguments-----------------------------------
reg		      [0:23]	 r24;	   // printing reg
reg              [0:1572863] data_in;	   // all data
reg      [`ROW*`width*3-1:0]data_out;	   // line out from module
integer   file_in, file_out, i, j, f;	   // file pointer's, loop index's
// -----------------------------------------------------------------------------
// --------------------------component arguments--------------------------------
reg      [`ROW*`width*3-1:0]  row_in;
reg 				CLK ;
reg				SET ;
reg				RST ;
wire     [`ROW*`width*3-1:0] row_out;
// -----------------------------------------------------------------------------
// ---------------------------------UUT-----------------------------------------
dirtylena UUT(
.row_in		(row_in),
.CLK		   (CLK),
.SET 		   (SET),
.RST 		   (RST),
.row_out       (row_out)
);
// -----------------------------------------------------------------------------
// ----------------------------Clock Generator----------------------------------
always 
begin 
CLK = 0; 
#5; 
CLK = 1; 
#5; 
end  
// -----------------------------------------------------------------------------
// ---------------------------start simulation----------------------------------
initial begin
file_in  = $fopen(`IN_FILE_NAME,"rb");
file_out = $fopen(`OUT_FILE_NAME,"wb");
f = $fread(data_in , file_in);
SET = 1'b0;			//first row in with the commend SET//
row_in = data_in[0:6143];
RST = 1'b1;
#5;
SET = 1'b1;
// -----------------------------------------------------------------------------
row_in = data_in[6144:12287];	//second row
RST = 1'b1;
SET = 1'b1;
// -----------------------------------------------------------------------------
for ( i=0 ; i<`ROW ; i=i+1 )    //all other rows
begin
	
	SET =  1'b1;
	row_in = data_in[12288+6144*i +:6144];
	RST =  1'b1; 
	data_out = row_out;   
	for (j=0 ; j<`COL ; j=j+1) 
		begin
			r24 = data_out[6120-24*j +:24];
			$fwrite(file_out, "%c%c%c" ,r24[0:7],r24[8:15],r24[16:23]);
		end
	#10;
end
// -----------------------------------------------------------------------------
$fclose(file_in);
$fclose(file_out);
$stop;
end
endmodule
// -------------------------------End-------------------------------------------		






