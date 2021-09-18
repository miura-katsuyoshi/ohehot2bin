`include "vunit_defines.svh"

`define CUT CUT

module onehot2bin%WIDTH%_tb;
    timeunit 1ns;
    timeprecision 1ps;

    parameter WIDTH = %WIDTH%;

    logic [WIDTH-1:0] bin;
    logic [2**WIDTH-1:0] onehot;
    logic error;

        function automatic bit [2**WIDTH-1:0] urandom_width();
            int i;
            bit [2**WIDTH-1:0] retval = 0;
            for(i=0; i<(2**WIDTH-1)/32+1; i++) begin
                $display("i=%d, $retval=%h", i, retval);
                retval = (retval << 32) | $urandom();
                $display("$retval=%h", retval);
            end
            return retval;
        endfunction

        function automatic bit is_onehot(
            input bit [2**WIDTH-1:0] in
        );
            int i;
            for(i=0; i<2**WIDTH; i++) begin
                if((1<<i) == in) return 1'b1;
            end
            return 1'b0;
        endfunction

    `TEST_SUITE begin

        `TEST_SUITE_SETUP begin
        end

        `TEST_CASE_SETUP begin
            bin = 0;
        end

        `TEST_CASE("normal_operation_test") begin
            int i;

            for(i=0; i<(2**WIDTH); i++) begin
                onehot = (1<<i);
                #10;
                `CHECK_EQUAL(bin, i);
                `CHECK_EQUAL(error, 1'b0);
            end
        end

        `TEST_CASE("error_detection_test") begin
            int i;
            for(i=0; i<256; i++) begin
                onehot = urandom_width();
                if(is_onehot(onehot)) begin
                    #10;
                    `CHECK_EQUAL(error, 1'b0);
                end
                else begin
                    #10;
                    `CHECK_EQUAL(bin, 0);
                    `CHECK_EQUAL(error, 1'b1);
                end
            end
        end

        `TEST_CASE_CLEANUP begin
        end

        `TEST_SUITE_CLEANUP begin
        end
    end;

    `WATCHDOG(1ms);

    onehot2bin #(
        .WIDTH(WIDTH)
    )
    `CUT (
        .onehot(onehot),
        .bin(bin),
        .error(error)
    );

endmodule
