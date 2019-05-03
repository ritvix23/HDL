module rd #(parameter n=8, p=8) (output wire [p-1:0] quotient, remainder, output wire done,
    input wire signed [n-1:0] x, y, input wire clk, reset, start);
    reg signed [p-1:0] r, rnext;
    reg [p-1:0] q, w, f;
    integer count;
    reg qbit, done_tick, d;
    integer z, t, i;

    assign quotient = q;
    assign remainder = r;
    assign done = done_tick;

    always @(posedge clk, posedge reset) begin
      if (reset) begin count = 0; done_tick = 1'b0; qbit = 1'b0; q = 0; r = 0; w=0; f=0 ;  end
      else if (start) begin rnext = x; count = 1; end
      else if (count>0) begin
            d=1'b0;
            t= rnext;
            if (t == 0) begin 
                f = {q[p-2:0], d};
                
                rnext = 0;

                q = {f[p-2:0], d};
                r= rnext;
                rnext = 0;  
                count = count +2;
                if (count==p+1||count==p+2) begin count=0; done_tick = 1'b1; end
            end
            else begin

        
                
                qbit = 1'b0;
                if (rnext[p-1]==0) begin z = 2*rnext - y; end
                else if (rnext[p-1]==1) begin z = 2*rnext + y; end 
                    rnext = z;
                    if (z<0) begin qbit = 1'b0; end
                    else begin qbit = 1'b1; end

                    w = {q[p-2:0], qbit};
                    i = rnext;
                    if (i!=0) begin   
                        r = rnext;
                        qbit = 1'b0;
                        if (rnext[p-1]==0) begin z = 2*r - y; end
                        else if (rnext[p-1]==1) begin z = 2*r + y; end 
                        rnext = z;
                        if (z<0) begin qbit = 1'b0; end
                        else begin qbit = 1'b1; end
                    end
                    else begin
                        rnext=0;
                        r= rnext;
                        qbit = 0;
                    end
                    q = {w[p-2:0], qbit};
                    count = count + 2;
                    if (count==p+1||count==p+2) begin count=0; done_tick = 1'b1; end
            end
        end
    end
endmodule
