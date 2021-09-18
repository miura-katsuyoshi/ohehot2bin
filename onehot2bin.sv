module onehot2bin #(
    parameter int WIDTH = 4
) (
    input logic [2**WIDTH-1:0] onehot,
    output logic [WIDTH-1:0] bin,
    output logic error
);

    function logic [WIDTH:0] onehot2bin_func(
        input logic [2**WIDTH-1:0] onehot
    );
        int i;
        for(i=0; i<2**WIDTH; i++) begin: gen_onehot2bin
            unique if((1<<i)==onehot) return i;
        end
        return {1,{WIDTH{1'b0}}};
    endfunction

    assign {error,bin} = onehot2bin_func( onehot );
endmodule
