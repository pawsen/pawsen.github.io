+++
title = "Mechanical advantage and efficiency"
author = ["The primary user account"]
lastmod = 2024-10-19T23:16:59+02:00
draft = false
+++

## Efficiency of friction devices <span class="tag"><span class="ATTACH">ATTACH</span></span> {#efficiency-of-friction-devices}


### Measured <span class="tag"><span class="ATTACH">ATTACH</span></span> {#measured}

Richard Delayney measured the friction, the data is from <https://www.ropelab.com.au/files/physics.pdf> or [physics.pdf](/home/paw/tmp/notes/notes/physics.pdf) p. 90.

{{< figure src="/home/paw/tmp/notes/notes/friction-devices.png" caption="<span class=\"figure-number\">Figure 1: </span>friction devices" >}}

<div class="table-caption">
  <span class="table-number">Table 1:</span>
  Measured "Force to lift 1kN"
</div>

| Device                       | Force to lift 1kN | Efficiency % |
|------------------------------|-------------------|--------------|
| Rock Exotica Omni Block 1.5  | 1.10              | 90.91        |
| Petzl P50                    | 1.12              | 89.29        |
| Petzl mini pmp               | 1.15              | 86.96        |
| BD pulley                    | 1.16              | 86.21        |
| CMI pulley                   | 1.25              | 80.00        |
| Petzl orange plastic on oval | 1.25              | 80.00        |
| Petzl micro traxion          | 1.14              | 87.72        |
| Petzl mini traxion           | 1.35              | 74.07        |
| Single karabiner             | 1.69              | 59.17        |
| Double karabiner             | 1.86              | 53.76        |
| Petzl IDs                    | 2.65              | 37.74        |
| Petzl GriGri 1               | 2.23              | 44.84        |
| Petzl GriGri 2               | 2.21              | 45.25        |
| CMC MPD                      | 1.07              | 93.46        |


### Theoratical <span class="tag"><span class="ATTACH">ATTACH</span></span> {#theoratical}

The theoretical efficiency can be estimated using the [capstan equation](https://en.wikipedia.org/wiki/Capstan_equation) (belt friction equation)

T_2 = T_1 exp<sup>&mu; &beta;</sup>

{{< figure src="/home/paw/tmp/notes/notes/capstan_equation.png" caption="<span class=\"figure-number\">Figure 2: </span>Capstan equation for belt friction" >}}

Using this simple friction law leads us to conclude that the frictional forces for a rope depends only on three things:

-   the tension in the rope
-   the coefficient of friction
-   the total angle of contact

{{< figure src="/home/paw/tmp/notes/notes/capstan_measured_friction.png" caption="<span class=\"figure-number\">Figure 3: </span>11.1mm Sterling HTP rope, 90 degree bend over 60mm polished Aluminium tube, 75kg test mass: raise, rest, then lower." >}}

-   Once the tension reaches 90kgf, the mass leaves the ground.
-   After a short time, hauling stops and the mass is left to rest with a holding tension around 80kgf.
-   This sequence is repeated two more times with small spikes up to 96kgf – these show the slightly larger effort required to overcome static friction.
-   The tension required to maintain upward movement is about 92kgf.
-   After a rest, the system is set to lower and the mass is lowered to the ground in one sequence with a lowering tension of about 53kgf.
-   The angle(β) through which contact occurs is 90 degrees, or π/2 radians

The friction is calculated as

\\(\mu = \frac{\ln \frac{T\_{raise}}{T\_{lower}} }{2 \beta}\\)

\\(\mu = \frac{\ln \frac{92 kgf}{53 kgf} }{2 \frac{\pi}{2} } = 0.175\\)

| Turns | Angle                          | 𝒆<sup>μβ</sup> = \\(\frac{W}{T\_{lower}}\\) | T<sub>lower</sub> required to lower 100kg |
|-------|--------------------------------|---------------------------------------------|-------------------------------------------|
| ¼     | 90°  = π/2 radians             | 1.32                                        | 75.97                                     |
| ½     | 180° = π  radians              | 1.73                                        | 57.71                                     |
| 1     | 360° = 2π radians              | 3.00                                        | 33.30                                     |
| 2     | 720° = 4π rads = 2 round turns | 9.02                                        | 11.09                                     |
| 3     | 6π  rads = 3 round turns       | 27.08                                       | 3.69                                      |
| 4     | 8π  rads = 4 round turns       | 81.31                                       | 1.23                                      |
| 5     | 10π rads = 5 round turns       | 244.15                                      | 0.41                                      |
| 6     | 12π rads = 6 round turns       | 733.15                                      | 0.14                                      |

We will get almost a 100-fold saving in effort when lowering if we take 4 round turns around an aluminium bar – which is probably where the “4-turn” rule-of-thumb for the tensionless hitch comes from

Other results from test using a 75kg mass

| Rope         | Host         | T<sub>raise</sub> | T<sub>lower</sub> | angle | β    |
|--------------|--------------|-------------------|-------------------|-------|------|
| Sterling HTP | 50mm alu     | 98                | 50                | 90    | 0.21 |
| Edelrid SS   | 50mm alu     | 88                | 35                | 180   | 0.15 |
| Edelrid SS   | 50mm alu     | 89                | 49                | 90    | 0.19 |
| Sterling HTP | 60mm anod    | 92                | 53                | 90    | 0.18 |
| Edelrid SS   | 60mm anod    | 87                | 36                | 180   | 0.14 |
| Edelrid SS   | 60mm anod    | 92                | 52                | 90    | 0.18 |
| Sterling HTP | 43mm gal     | 103               | 47                | 90    | 0.25 |
| Edelrid SS   | 43mm gal     | 125               | 37                | 180   | 0.19 |
| Edelrid SS   | 43mm gal     | 92                | 47                | 90    | 0.21 |
| Edelrid SS   | 10mm steel   | 127               | 29                | 180   | 0.24 |
| Edelrid SS   | 12mm steel   | 140               | 31                | 180   | 0.24 |
| Edelrid SS   | Flat 4x2wood | 179               | 17                | 180   | 0.37 |
| Edelrid SS   | Tall 4x2wood | 140               | 15                | 180   | 0.36 |
| Edelrid SS   | concrete     | 135               | 34                | 90    | 0.44 |


## Mechanical advantage <span class="tag"><span class="ATTACH">ATTACH</span></span> {#mechanical-advantage}

Notes from <https://www.ropelab.com.au/pulley-system-analysis/>


### Z-rig / 3:1 {#z-rig-3-1}

The mechanical advantage for a 3:1(Z-rig)

{{< figure src="/home/paw/tmp/notes/notes/z-rig-forces.jpg" caption="<span class=\"figure-number\">Figure 4: </span>3:1(or Z-rig) with forces in yellow" >}}

The force on the free end of the rope is `1`, after pulley P2 with efficiency `P2` the force is `1*P2=P2` and after pulley `P1` the force is `P1P2`. The force acting on the block is the sum of all forces, `1+P2+P1P2`.

The MA for a Z-rig in two different configurations

1.  P1 is a pulley `P1=90%`, P2 is a carabiner `P2=50%`
2.  P1 is a carabiner `P1=50%`, P2 is a pulley `P2=90%`

|    | 1 | P1  | P2  | P1P2 | MA   |
|----|---|-----|-----|------|------|
|    | x |     | x   | x    |      |
| 1. | 1 | 0.9 | 0.5 | 0.45 | 1.95 |
| 2. | 1 | 0.5 | 0.9 | 0.45 | 2.35 |

(**x** indicates the term is used for calculating MA)

Since `P1` only appears in higher order terms, the MA is higher when `P2` has the highest efficiency. A general rule of thumb seems to be

> the best pulley closest to hand


### Generalization {#generalization}

As a premise, the number of terms in the calculation of MA for any pulley system follows

> Each term, a product of combination of pulley efficiencies, appears at maximum once in a calculated MA (1). Further, each pulley’s efficiency may appear at maximum once in each term (2).

ie, number of terms are \\(2^N\\) where \\(N\\) is the number of pulleys

{{< figure src="/home/paw/tmp/notes/notes/4pulley_combinations.png" caption="<span class=\"figure-number\">Figure 5: </span>Four order terms in any 4-pulley system. The terms to include in MA have to be determined based on the actual setup/free body diagram" >}}

The first row shows how the terms contribute to the MA, assuming all pulley efficiencies as 80%.
