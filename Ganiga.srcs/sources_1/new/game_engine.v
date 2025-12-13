`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/20/2025 11:13:45 PM
// Design Name: 
// Module Name: game_engine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module game_engine(
    input  wire       clk,
    input  wire       rst_ni,
    input  wire       tick,
    input  wire       btn_left,
    input  wire       btn_right,
    input  wire       btn_fire,

    output wire       game_playing,

    output wire [9:0] player_x,
    output wire [9:0] player_y,
    output wire       bullet_active,
    output wire [9:0] bullet_x,
    output wire [9:0] bullet_y,
    output wire [4:0] enemies_alive,
    output wire [9:0] enemy_group_x,
    output wire [9:0] enemy_group_y
);

    // ----------------------------
    // State (MENU / PLAY)
    // ----------------------------
    localparam ST_MENU = 1'b0;
    localparam ST_PLAY = 1'b1;
    reg state;

    // Button edge detect (sample at tick)
    reg fire_d;
    wire fire_rise = btn_fire && !fire_d;

    // Raw signals from submodules
    wire [9:0] p_x_raw, p_y_raw;
    wire       b_act_raw;
    wire [9:0] b_x_raw, b_y_raw;
    wire [4:0] en_alive_raw;
    wire [9:0] en_grp_x_raw, en_grp_y_raw;
    wire       bullet_hit_ack;

    // Hold the game logic in reset while we're in MENU
    wire rst_game_ni = rst_ni && (state == ST_PLAY);

    // State transitions
    always @(posedge clk) begin
        if (!rst_ni) begin
            state  <= ST_MENU;
            fire_d <= 1'b0;
        end else begin
            if (tick) begin
                fire_d <= btn_fire;

                // MENU -> PLAY on fire
                if (state == ST_MENU) begin
                    if (fire_rise) state <= ST_PLAY;
                end else begin
                    // PLAY -> MENU when enemies cleared (simple "game over")
                    if (en_alive_raw == 5'd0) state <= ST_MENU;
                end
            end
        end
    end

    assign game_playing = (state == ST_PLAY);

    // ----------------------------
    // Submodules (existing)
    // ----------------------------
    player_control #(
        .START_X(320),
        .START_Y(440),
        .SPEED(4)
    ) p_ctrl (
        .clk(clk),
        .rst_ni(rst_game_ni),
        .tick(tick),
        .btn_left(btn_left),
        .btn_right(btn_right),
        .x(p_x_raw),
        .y(p_y_raw)
    );

    enemy_control e_ctrl (
        .clk(clk),
        .rst_ni(rst_game_ni),
        .tick(tick),
        .bullet_active(b_act_raw),
        .bullet_x(b_x_raw),
        .bullet_y(b_y_raw),
        .bullet_hit_ack(bullet_hit_ack),
        .enemies_alive(en_alive_raw),
        .group_x(en_grp_x_raw),
        .group_y(en_grp_y_raw)
    );

    bullet bullet_inst (
        .clk(clk),
        .rst_ni(rst_game_ni),
        .fire(btn_fire),
        .tick(tick),
        .player_x(p_x_raw),
        .player_y(p_y_raw),
        .active(b_act_raw),
        .bullet_x(b_x_raw),
        .bullet_y(b_y_raw)
    );

    // ----------------------------
    // Outputs (menu gating)
    // ----------------------------
    // A fixed "ship" location for the menu screen
    localparam [9:0] MENU_PX = 10'd320;
    localparam [9:0] MENU_PY = 10'd440;

    assign player_x = (state == ST_PLAY) ? p_x_raw : MENU_PX;
    assign player_y = (state == ST_PLAY) ? p_y_raw : MENU_PY;

    // Filter bullet active signal when hit + disable in menu
    assign bullet_active = (state == ST_PLAY) ? (b_act_raw && !bullet_hit_ack) : 1'b0;
    assign bullet_x      = b_x_raw;
    assign bullet_y      = b_y_raw;

    // Hide enemies in menu
    assign enemies_alive = (state == ST_PLAY) ? en_alive_raw : 5'd0;
    assign enemy_group_x = en_grp_x_raw;
    assign enemy_group_y = en_grp_y_raw;

endmodule
