package FIFO_coverage_pkg;
import FIFO_transaction_pkg::*;
import shared_pkg::*;

    class FIFO_coverage;
        FIFO_transaction F_cvg_txn;
        
        covergroup FIFO_cvg;

            wr_cvg: coverpoint F_cvg_txn.wr_en;
            rd_cvg: coverpoint F_cvg_txn.rd_en;
            wr_ack_cvg : coverpoint F_cvg_txn.wr_ack;
            overflow_cvg : coverpoint F_cvg_txn.overflow;
            full_cvg : coverpoint F_cvg_txn.full;
            empty_cvg : coverpoint F_cvg_txn.empty;
            almostfull_cvg : coverpoint F_cvg_txn.almostfull;
            almostempt_cvg : coverpoint F_cvg_txn.almostempty;
            underflow_cvg : coverpoint F_cvg_txn.underflow;

            wr_ack_C: cross wr_cvg, rd_cvg , wr_ack_cvg{
                ignore_bins a0 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {0} && binsof(wr_ack_cvg) intersect {1};
                ignore_bins a1 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {1} && binsof(wr_ack_cvg) intersect {1};
            }
            overflow_C: cross wr_cvg, rd_cvg , overflow_cvg{
                ignore_bins b0 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {0} && binsof(overflow_cvg) intersect {1};
                ignore_bins b1 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {1} && binsof(overflow_cvg) intersect {1};
            }
            full_C: cross wr_cvg, rd_cvg , full_cvg{
                ignore_bins c0 = binsof(wr_cvg) intersect {1} && binsof(rd_cvg) intersect {1} && binsof(full_cvg) intersect {1};
                ignore_bins c1 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {1} && binsof(full_cvg) intersect {1};
            }
            empty_C: cross wr_cvg, rd_cvg , empty_cvg;
            almostfull_C: cross wr_cvg, rd_cvg , almostfull_cvg;
            almostempty_C: cross wr_cvg, rd_cvg , almostempt_cvg;
            underflow_C: cross wr_cvg, rd_cvg , underflow_cvg{
                ignore_bins d0 = binsof(wr_cvg) intersect {1} && binsof(rd_cvg) intersect {0} && binsof(underflow_cvg) intersect {1};
                ignore_bins d1 = binsof(wr_cvg) intersect {0} && binsof(rd_cvg) intersect {0} && binsof(underflow_cvg) intersect {1};
            }


        endgroup

        function new();
            FIFO_cvg = new();
            F_cvg_txn = new();
        endfunction

        function void sample_data(FIFO_transaction F_txn);
            F_cvg_txn = F_txn;
            FIFO_cvg.sample();
        endfunction


    endclass
    
endpackage