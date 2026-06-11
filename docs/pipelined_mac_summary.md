# Pipelined ASIC MAC Summary

## Project Overview

This section documents the pipelined MAC variant implemented after completing the baseline unpipelined ASIC MAC flow. The goal was to evaluate whether adding pipeline stages could improve the physical timing result compared to the baseline design.

## Design Change

The baseline MAC performed multiply and accumulate logic in a single sequential path. The pipelined version separates the operation into multiple stages:

1. Register input operands
2. Compute and register the product
3. Accumulate the registered product into the output register

This adds pipeline latency but reduces the amount of combinational logic between registers.

## Genus Synthesis Result

The pipelined MAC improved the synthesis-level timing limit compared to the baseline.

| Design | Smallest Passing Genus Period | First Failing Genus Period | Estimated Genus Fmax |
|---|---:|---:|---:|
| Baseline MAC | 450 ps | 400 ps | ~2.22 GHz |
| Pipelined MAC | 400 ps | 350 ps | ~2.50 GHz |

This shows that pipelining improved the synthesis-level frequency target, but at the cost of additional registers and design complexity.

## Final Pipelined Post-Route Result

The pipelined MAC was physically implemented using the same Cadence Innovus-based flow as the baseline design. A 700 ps target passed first, then the design was rerun at 600 ps. The 600 ps post-route result met setup timing.

| Metric | Pipelined MAC Result |
|---|---:|
| Target period | 600 ps |
| Estimated frequency | ~1.67 GHz |
| Setup timing | MET |
| Worst setup slack | +2.457 ps |
| Required time | 590.786 ps |
| Arrival time | 588.329 ps |
| Standard-cell area | 1204.425 um² |
| Core area | 1934.669 um² |
| Effective utilization | 62.355% |
| Total power | 0.47428404 mW |

## Baseline vs Pipelined Comparison

| Metric | Baseline MAC | Pipelined MAC |
|---|---:|---:|
| Post-route target period | ~610 ps | 600 ps |
| Estimated frequency | ~1.64 GHz | ~1.67 GHz |
| Worst setup slack | +1.305 ps | +2.457 ps |
| Standard-cell area | 1224.253 um² | 1204.425 um² |
| Core area | 1605.433 um² | 1934.669 um² |
| Effective utilization | 76.257% | 62.355% |
| Total power | 0.46341545 mW | 0.47428404 mW |

## Energy Estimate

Assuming one MAC operation per cycle after pipeline fill:

| Metric | Baseline MAC | Pipelined MAC |
|---|---:|---:|
| Throughput | ~1.64 GMAC/s | ~1.67 GMAC/s |
| Power | 0.46341545 mW | 0.47428404 mW |
| Estimated energy per MAC | ~0.282 pJ/MAC | ~0.284 pJ/MAC |

## Interpretation

The pipelined MAC successfully closed post-route timing at 600 ps, slightly improving the final physical frequency target compared to the baseline design. The pipelined design also had slightly lower reported standard-cell area, but it used a larger core area due to a looser physical implementation. Power increased slightly from approximately 0.463 mW to 0.474 mW.

The main value of the pipelined design is that it demonstrates a second ASIC implementation point with improved timing closure and a clear design tradeoff. The frequency improves slightly, but the power increase mostly cancels out the energy-per-operation benefit.

## Limitations

The reported power is based on tool-estimated switching activity rather than simulation-derived activity. A future improvement would be to use VCD/SAIF-based activity annotation for more accurate power comparison.

The baseline design completed post-route timing closure and connectivity checking, but Innovus DRC reported remaining via-enclosure violations. These are treated as future physical-verification cleanup rather than final signoff closure.