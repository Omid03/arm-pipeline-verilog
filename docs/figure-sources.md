# Figure provenance

Page numbers are one-based. The PNG files preserve the source diagrams; they are not generated netlists or newly simulated waveforms.

| Image | Source | Extraction | README position |
| --- | --- | --- | --- |
| `pipeline-overview.png` | `00-Intro-ARM.pdf`, page 10, figure 5 | Diagram crop rendered at 4× scale | Phase 2, after the hazard-control description |
| `forwarding-datapath.png` | `05-ARM-Forwarding.pdf`, page 4, figure 1 | Diagram and legend crop rendered at 4× scale | Phase 3, after the forwarding architecture description |
| `sram-integration.png` | `06-SRAM-Simulation.pdf`, page 4 | Diagram and legend crop rendered at 4× scale | Phase 4, after the memory-model description |

Editable source files supplied separately are retained as `docs/design/ARM.vsdx` and `docs/design/ARM_Forwarding.vsdx`. Direct Visio conversion was unavailable in the preparation environment, so the corresponding specification drawings were used for browser-readable PNGs. No claim of byte-for-byte or revision equivalence between the Visio files and the PDF drawings is made. An editable SRAM diagram was not supplied separately.

The source documents identify the University of Tehran Computer Architecture laboratory; the introduction credits its listed authors and the forwarding/SRAM briefs credit Omid Gholizadeh and Amir Reza Gholami. Attribution remains here even though the README presents the work by its engineering problems. The source archive contains no explicit redistribution license for these drawings.

The ID-stage image on page 2 is a module-interface code screenshot, not a circuit schematic; it is omitted. Unrelated document logos, page borders and instructional text are also omitted. Architectural diagrams illustrate intended behavior and do not supersede the RTL findings in `technical-review.md`.
