module player_sprite #(
    parameter SPRITE_W = 16,
    parameter SPRITE_H = 16
)(
    input  wire       clk,
    input  wire [9:0] x,
    input  wire [9:0] y,
    input  wire [9:0] player_x,
    input  wire [9:0] player_y,
    output reg        px_on,
    output reg [3:0]  r, g, b
);

    // 1. เช็คว่า Pixel ปัจจุบันอยู่ในกรอบ Sprite ไหม
    wire inside = (x >= player_x) && (x < player_x + SPRITE_W) &&
                  (y >= player_y) && (y < player_y + SPRITE_H);

    // 2. คำนวณ Address
    wire [9:0] sx = x - player_x;
    wire [9:0] sy = y - player_y;
    wire [7:0] addr = sy * SPRITE_W + sx;

    // 3. ดึงค่าจาก ROM (Latency 1 Clock)
    wire [11:0] rom_data;
    blk_mem_gen_0 player_rom (
        .clka (clk),
        .addra(addr),
        .douta(rom_data)
    );

    // 4. รอสัญญาณ inside ให้ตรงกับข้อมูลที่ออกมาจาก ROM (Delay 1 Clock)
    reg inside_reg;
    always @(posedge clk) begin
        inside_reg <= inside;
    end

    // 5. ส่งค่าสีออก (ใช้ rom_data ได้เลย เพราะมันมาช้า 1 clock พร้อมกับ inside_reg พอดี)
    always @(*) begin
        if (inside_reg) begin
            px_on = 1'b1;
            r     = rom_data[11:8]; // ดึงจาก rom_data โดยตรง
            g     = rom_data[7:4];
            b     = rom_data[3:0];
        end else begin
            px_on = 1'b0;
            r = 0; g = 0; b = 0;
        end
    end

endmodule