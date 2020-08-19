class GOlViewer {
    constructor(seed_img) {
        this.nx = 4
        this.img_size = 64
        this.container = null
        this.canvas = document.createElement('canvas')
        this.canvas.height = this.img_size
        this.canvas.width = this.img_size * this.nx
        
        // this.container.append(this.canvas)
        this.regl = createREGL(this.canvas)
        
        this.map_texture = this.regl.texture({
            shape: [ this.canvas.width, this.canvas.height ]
        })
        this.textures = Array(2).fill().map(() => (
            this.regl.texture({
                shape: [ this.canvas.width, this.canvas.height ]
            })
        ))
        this.buffers = this.textures.map(data => (
            this.regl.framebuffer({ color: data })
        ))
        this.step = 0
        this.seed_img = seed_img
        this.shaders = create_shader(this.regl, this.buffers, this.map_texture)
        // this.canvas.onclick = () => this.reset()
    }
    start() {
        const { updateLife, setupQuad } = this.shaders
        this.regl.frame(() => {
            if (this.step > 1000) {
                return
            }
            setupQuad(() => {
                this.regl.draw()
                if (this.step > 15) {
                    updateLife()
                }
                this.step += 1
            })
        })
    }
    reset() {
        this.step = 0
        for (let i = 0; i < this.nx; i++) {
            this.textures[0].subimage(this.seed_img, i*this.img_size, 0)
            this.textures[1].subimage(this.seed_img, i*this.img_size, 0)
        }
    }
    resize(nx) {
        this.nx = nx
        // this.canvas.height = this.img_size
        this.canvas.width = this.img_size * this.nx
        this.map_texture.resize(this.img_size*this.nx, this.img_size)
        this.buffers.forEach(b => {
            b.resize(this.img_size*this.nx, this.img_size)
        })
        this.reset()
    }
    moveTo(container) {
        this.container = container
        container.append(this.canvas)
        try {
            // this.container.remove()
            document.querySelector('.images.hidden').classList.remove('hidden')
        } catch {}
        const images = container.querySelectorAll('img')
        if (images.length != this.nx) {
            this.resize(images.length)
        }
        images.forEach((img, idx) => {
            this.map_texture.subimage(img, idx*this.img_size, 0)
        })
        container.querySelector('.images').classList.add('hidden')
        this.reset()
    }
}
