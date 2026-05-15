package FIFO_coverage_pkg;
import uvm_pkg::*;
import FIFO_sequence_item_pkg::*;
`include "uvm_macros.svh"

    class FIFO_coverage extends uvm_component;
        `uvm_component_utils(FIFO_coverage);

        uvm_analysis_export #(FIFO_sequence_item) cv_export;
        uvm_tlm_analysis_fifo #(FIFO_sequence_item) cv_fifo;
        FIFO_sequence_item cv_seq_item;

        covergroup FIFO_cvg;

            wr_cvg: coverpoint cv_seq_item.wr_en;
            rd_cvg: coverpoint cv_seq_item.rd_en;
            wr_ack_cvg : coverpoint cv_seq_item.wr_ack;
            overflow_cvg : coverpoint cv_seq_item.overflow;
            full_cvg : coverpoint cv_seq_item.full;
            empty_cvg : coverpoint cv_seq_item.empty;
            almostfull_cvg : coverpoint cv_seq_item.almostfull;
            almostempt_cvg : coverpoint cv_seq_item.almostempty;
            underflow_cvg : coverpoint cv_seq_item.underflow;

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

        function new(string name = "FIFO_coverage", uvm_component parent = null);
            super.new(name,parent);
            FIFO_cvg = new();
        endfunction

        function void build_phase(uvm_phase phase);
            super.build_phase(phase);
            cv_export = new("cv_export",this);
            cv_fifo = new("cv_fifo",this);
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            cv_export.connect(cv_fifo.analysis_export);
        endfunction

         task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                cv_fifo.get(cv_seq_item);
                FIFO_cvg.sample();
            end
         endtask

    endclass


endpackage