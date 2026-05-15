// comparison module

module comparison(
            clk_p_i,
            reset_n_i,
            valid_in,
            Q_acc,
            I_acc,
            theta_in,
            theta_out
    );

    input clk_p_i;
    input reset_n_i;
    input valid_in;
    input signed [11:0] Q_acc;
    input signed [11:0] I_acc;
    input [5:0] theta_in;
    output reg [5:0] theta_out;



    // interconnection

    reg [12:0] max_power;
    reg [5:0] current_theta;
    reg [12:0] new_power;
    reg [11:0] absolute_Q_acc;
    reg [11:0] absolute_I_acc;
    

    //combinational

    //power calculation
    always @(*) begin
        case(Q_acc[12])
                1'b0: absolute_Q_acc = Q_acc[11:0];
                1'b1: absolute_Q_acc = ~Q_acc[11:0] + 1;
        endcase

        case(I_acc[12])
                1'b0: absolute_I_acc = I_acc[11:0];
                1'b1: absolute_I_acc = ~I_acc[11:0] + 1;
        endcase

        new_power = absolute_Q_acc + absolute_I_acc;
    end

    // sequential state update
    always @(posedge clk_p_i or negedge reset_n_i) begin
        if (!reset_n_i) begin
            max_power <= 13'd0;
            current_theta <= 6'd0;
            theta_out <= 6'd0;
        end 
        else if (valid_in) begin
            if (new_power > max_power) begin
                max_power <= new_power;
                current_theta <= theta_in;
                theta_out <= theta_in;
            end 
            else begin
                max_power <= max_power;
                current_theta <= current_theta;
                theta_out <= current_theta;
            end
        end
    end

endmodule

