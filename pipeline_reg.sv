module pipeline_reg #(
    parameter int DATA_WIDTH = 32
) (
    input  logic                  clk,
    input  logic                  rst_n,

    // Input interface
    input  logic                  in_valid,
    output logic                  in_ready,
    input  logic [DATA_WIDTH-1:0] in_data,

    // Output interface
    output logic                  out_valid,
    input  logic                  out_ready,
    output logic [DATA_WIDTH-1:0] out_data
);

    // Internal storage
    logic [DATA_WIDTH-1:0] data_q;
    logic                 valid_q;

    // Ready when empty OR downstream is ready to consume
    assign in_ready  = ~valid_q || out_ready;

    // Output signals
    assign out_valid = valid_q;
    assign out_data  = data_q;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            valid_q <= 1'b0;
            data_q  <= '0;
        end else begin
            // Load new data when handshake occurs
            if (in_valid && in_ready) begin
                data_q  <= in_data;
                valid_q <= 1'b1;
            end
            // Clear valid when downstream consumes and no new data arrives
            else if (out_ready && out_valid) begin
                valid_q <= 1'b0;
            end
        end
    end

endmodule
