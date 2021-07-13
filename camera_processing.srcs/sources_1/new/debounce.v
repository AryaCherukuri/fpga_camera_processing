module debounce(
	input clk,
	input i,
	output o
	);
	
reg o;
reg [23:0]c;

always @ ( posedge clk)
	begin
		if ( clk == 1'b1 )
			begin
				if ( i == 1'b1 )
					begin
						if ( c == 24'b111111111111111111111111 )
							begin
								o <= 1'b1;
							end
						else
							begin
								o <= 1'b0;
							end
							c <= ( c + 1 );
					end
				else
					begin
						c <= { 1'b0 };
						o <= 1'b0;
					end
			end
	end
endmodule

