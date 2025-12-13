`timescale 1ns / 1ps

// menu_fsm_user.v
// Reset => MENU. Press FIRE => PLAY.
module menu_fsm(
    input  wire clk,
    input  wire rst_ni,
    input  wire tick,
    input  wire btn_fire,
    output wire game_playing
);
    localparam ST_MENU = 1'b0;
    localparam ST_PLAY = 1'b1;

    reg state;
    always @(posedge clk) begin
        if (!rst_ni) begin
            state <= ST_MENU;
        end else if (tick) begin
            if (state==ST_MENU && btn_fire) state <= ST_PLAY;
        end
    end

    assign game_playing = (state==ST_PLAY);
endmodule
