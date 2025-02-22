<script lang="ts">
  import { onMount, onDestroy } from "svelte";
  import createREGL, { Regl, DrawCommand } from "regl";
  import { browser } from "$app/environment";

  // --- SquircleMaskGenerator Class using regl ---
  class SquircleMaskGenerator {
    private canvas: HTMLCanvasElement;
    private regl: Regl | null = null;
    private drawCommand: DrawCommand | null = null;

    // constructor() {
    //   this.createContext();
    //   this.canvas = document.createElement("canvas");
    //   this.canvas.style.display = "none";
    //   document.body.appendChild(this.canvas);
    // }

    constructor() {
      this.canvas = document.createElement("canvas");
      this.canvas.style.display = "none";
      this.canvas.width = 512;
      this.canvas.height = 512;
      document.body.appendChild(this.canvas);

      this.regl = createREGL({
        canvas: this.canvas,
        attributes: { preserveDrawingBuffer: true },
      });

      this.drawCommand = this.regl({
        frag: `
            precision mediump float;
            varying vec2 v_uv;
            uniform vec2 resolution;
            uniform float radius;
            uniform float borderWidth;
            uniform vec3 borderColor;
            uniform float shadowDistance;
            uniform float n;
            const float aa = 1.0;
  
            // Squircle SDF function
            vec3 sdSquircle(vec2 p, float r, float n) {
                p = p / r;
                vec2 gs = sign(p);
                vec2 ps = abs(p);
                float gm = pow(ps.x, n) + pow(ps.y, n);
                float gd = pow(gm, 1.0 / n) - r;
                vec2 g = gs * pow(ps, vec2(n - 1.0)) * pow(gm, 1.0 / n - 1.0);
                p = abs(p);
                if (p.y > p.x) p = p.yx;
                n = 2.0 / n;
                float s = 1.0;
                float d = 1e20;
                const int num = 12;
                vec2 oq = vec2(1.0, 0.0);
                for (int i = 1; i < num; i++) {
                    float h = float(i) / float(num - 1);
                    vec2 q = vec2(pow(cos(h * 3.1415927 / 4.0), n),
                                  pow(sin(h * 3.1415927 / 4.0), n));
                    vec2 pa = p - oq;
                    vec2 ba = q - oq;
                    vec2 z = pa - ba * clamp(dot(pa, ba) / dot(ba, ba), 0.0, 1.0);
                    float d2 = dot(z, z);
                    if (d2 < d) {
                        d = d2;
                        s = pa.x * ba.y - pa.y * ba.x;
                    }
                    oq = q;
                }
                return vec3(sqrt(d) * sign(s) * r, g);
            }
            
            void main() {
              vec2 center = resolution * 0.5;
              vec2 p = (v_uv * resolution) - center;
              
              // Main shape
              vec3 sd = sdSquircle(p, radius, n);
              float d = sd.x;
              
              // Fill (anti-aliased)
              float shapeAlpha = smoothstep(-aa, aa, -d);
              vec4 shapeColor = vec4(0.0, 0.0, 0.0, shapeAlpha);
              
              // Border
            //   float borderMask = smoothstep(-aa, aa, abs(d) - borderWidth);
            //   vec4 borderCol = vec4(borderColor, borderMask);
              
              // Composite layers
            //   gl_FragColor = mix(vec4(0.0, 0.0, 0.0, 0.0), borderCol, borderCol.a);
            //   gl_FragColor = mix(gl_FragColor, shapeColor, shapeColor.a);
            gl_FragColor = shapeColor;
            }
          `,
        vert: `
            precision mediump float;
            attribute vec2 position;
            varying vec2 v_uv;
            void main() {
              v_uv = position * 0.5 + 0.5;
              gl_Position = vec4(position, 0, 1);
            }
          `,
        attributes: {
          position: [
            [-1, -1],
            [1, -1],
            [-1, 1],
            [-1, 1],
            [1, -1],
            [1, 1],
          ],
        },
        uniforms: {
          resolution: (ctx: any, props: any) => props.resolution,
          radius: (ctx: any, props: any) => props.radius,
          borderWidth: (ctx: any, props: any) => props.borderWidth,
          borderColor: (ctx: any, props: any) => props.borderColor,
          shadowDistance: (ctx: any, props: any) => props.shadowDistance,
          n: (ctx: any, props: any) => props.n,
        },
        count: 6,
      });
    }

    public generateImage(
      width: number,
      height: number,
      radius: number,
      borderWidth: number,
      borderColor: string,
      shadowDistance: number,
      n: number
    ): string {
      if (!this.regl || !this.drawCommand) {
        throw new Error("Context is not created. Call createContext() first.");
      }

      this.canvas.width = width;
      this.canvas.height = height;

      this.regl.clear({ color: [0, 0, 0, 0], depth: 1 });

      this.drawCommand({
        resolution: [width, height],
        radius,
        borderWidth,
        borderColor: this.parseColor(borderColor),
        shadowDistance,
        n,
      });

      return this.canvas.toDataURL("image/png");
    }

    public destroyContext(): void {
      if (this.regl) {
        this.regl.destroy();
        this.regl = null;
      }
      if (this.canvas && this.canvas.parentNode) {
        this.canvas.parentNode.removeChild(this.canvas);
      }
    }

    private parseColor(cssColor: string): [number, number, number] {
      const tempElem = document.createElement("div");
      tempElem.style.color = cssColor;
      document.body.appendChild(tempElem);
      const computed = getComputedStyle(tempElem).color;
      document.body.removeChild(tempElem);
      const result = /^rgba?\((\d+),\s*(\d+),\s*(\d+)/i.exec(computed);
      if (!result) {
        throw new Error("Unable to parse color: " + cssColor);
      }
      return [
        parseInt(result[1], 10) / 255,
        parseInt(result[2], 10) / 255,
        parseInt(result[3], 10) / 255,
      ];
    }

    public getCanvas(): HTMLCanvasElement {
      return this.canvas;
    }
  }
  // --- End SquircleMaskGenerator Class ---

  let radius = 255;
  let n = 4;
  let base64Image = "";
  let generator: SquircleMaskGenerator;
  let debugCanvas: HTMLCanvasElement;

  function updateImage() {
    if (generator) {
      base64Image = generator.generateImage(512, 512, radius, 4, "red", 10, n);
      // Ensure the base64Image is a valid data URL
      base64Image = `data:image/png;base64,${base64Image.split(",")[1]}`;

      // Draw the mask on the debug canvas
      const ctx = debugCanvas.getContext("2d");
      if (ctx) {
        const img = new Image();
        img.onload = () => {
          ctx.clearRect(0, 0, debugCanvas.width, debugCanvas.height);
          ctx.drawImage(img, 0, 0);
        };
        img.src = base64Image;
      }
    }
  }

  onMount(() => {
    if (browser) {
      generator = new SquircleMaskGenerator();
      updateImage();
    }
  });

  onDestroy(() => {
    if (browser) {
      generator.destroyContext();
    }
  });
</script>

<svelte:head>
  <title>Squircle Mask Generator Demo</title>
</svelte:head>

<main>
  <h1>Squircle Mask Generator Demo</h1>
  <!-- <div class="slider-container">
    <label for="radius">Radius: {radius}px</label>
    <input
      type="range"
      id="radius"
      min="50"
      max="300"
      bind:value={radius}
      on:input={updateImage}
    />
  </div> -->
  <div class="slider-container">
    <label for="n">Squareness: {n.toFixed(1)}</label>
    <input
      type="range"
      id="n"
      min="2"
      max="16"
      step="0.1"
      bind:value={n}
      on:input={updateImage}
    />
  </div>
  <div class="flex flex-row gap-2 flex-wrap">
    <div
      class="masked"
      style="mask-image: url('{base64Image}'); -webkit-mask-image: url('{base64Image}');"
    >
      <img class="w-full" src="/imgs/thumbnails/hands-preview.jpg" />
    </div>
    <div
      class="masked"
      style="mask-image: url('{base64Image}'); -webkit-mask-image: url('{base64Image}');"
    >
      <img class="w-full" src="/imgs/thumbnails/gan-portrait.jpg" />
    </div>
    <canvas bind:this={debugCanvas} width="512" height="512"></canvas>
  </div>
</main>

<style>
  .masked {
    width: 512px;
    height: 512px;
    position: relative;
    mask-size: cover;
    -webkit-mask-size: cover;
    mask-repeat: no-repeat;
    -webkit-mask-repeat: no-repeat;
  }
  .slider-container {
    margin: 1rem 0;
  }
  canvas {
    border: 1px solid #ccc;
    margin-top: 1rem;
  }
</style>
