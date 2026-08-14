## Logic Synthesis & Static Timing Analysis

The TERME core is fully synthesizable and has been verified for both area and timing using **Yosys** and **OpenSTA**. The baseline implementation targets the **Nangate 45nm Open Cell Library**.

### Area Report
* **Target Library:** Nangate 45nm
* **Total Core Area:** ~22,846 µm²

*Note: Area metrics reflect the standalone processor core, excluding external memory macros which are accessed via standard bus interfaces.*

### Timing & Performance ($F_{max}$)
Static Timing Analysis (STA) was performed using standard `.sdc` constraints, factoring in clock uncertainty (50ps) and realistic network latency. 

* **Critical Path Setup Slack:** +0.015 ns (MET)
* **Maximum Frequency ($F_{max}$):** **~410 MHz**

The positive slack confirms the core cleanly meets timing at 400+ MHz on a 45nm node.