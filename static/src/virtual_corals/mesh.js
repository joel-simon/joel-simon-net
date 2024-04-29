
class CoralAnimationViewer {
    constructor(path, max_points=20000) {
        this.path = path;
        this.frame = null;
        this.num_frames = null;
        this.all_frames_loaded = false;

        this.dynamicMesh = new DynamicMesh(max_points);
        this.dynamicMesh.coral = this
    }

    loadLastFrame() {
        var key = this.path.split('/')[2]
        console.time('last_frame: '+key)
        return new Promise((resolve, reject) => {
            var promises = [
                array_promise(this.path+'last_vert_array', Float32Array),
                array_promise(this.path+'last_color_array', Float32Array),
                array_promise(this.path+'last_face_array', Uint32Array),
            ]
            Promise.all(promises).then((values) => {
                this.frame = 0;
                this.dynamicMesh.update(values[0], values[1], values[2]);
                console.timeEnd('last_frame: '+key)
                resolve();
            }).catch(reject);
        });
    }

    loadAllFrames() {
        console.time('loadAllFrames'+this.path)
        return new Promise((resolve, reject) => {
            var promises = [
                array_promise(this.path+'vert_array', Float32Array),
                array_promise(this.path+'color_array', Float32Array),
                array_promise(this.path+'face_array', Uint32Array),
                array_promise(this.path+'vert_indices', Uint32Array),
                array_promise(this.path+'face_indices', Uint32Array),
            ]
            Promise.all(promises).then((values) => {
                this.verts = values[0];
                this.colors = values[1];
                this.faces = values[2];
                this.vert_indices = values[3];
                this.face_indices = values[4];
                this.all_frames_loaded = true;
                this.num_frames = this.face_indices.length;
                this.setFrame(this.num_frames-1);
                console.timeEnd('loadAllFrames'+this.path)
                resolve();
            }).catch(reject);
        });
    }

    addToScene(scene) {
        scene.add(this.dynamicMesh.mesh)
        return this;
        // scene.add(this.instanceMesh.mesh)
    }
    getPosition(x, y, z) {
        return this.dynamicMesh.mesh.position;
    }
    getCenter() {
        return this.dynamicMesh.geometry.boundingSphere.center
    }
    setPosition(x, y, z) {
        this.dynamicMesh.mesh.position.set(x, y, z);
        // this.instanceMesh.mesh.position.set(x, y, z);
        return this;
    }
    setRotation(x, y, z) {
        this.dynamicMesh.mesh.rotation.set(x, y, z);
        // this.instanceMesh.mesh.rotation.set(x, y, z);
        return this;
    }
    setScale(scale) {
        this.dynamicMesh.mesh.scale.set(scale, scale, scale);
        // this.instanceMesh.mesh.scale.set(scale, scale, scale);
        return this;
    }

    setFrame(frame) {
        if (!this.all_frames_loaded) {
            throw('Attempting to set a frame not loaded.');
        }
        if (frame >= this.num_frames || frame < 0) {
            throw('Invalid frame', frame);
        }

        this.frame = frame;
        var vert_end = this.vert_indices[this.frame];
        var face_end = this.face_indices[this.frame];
        var vert_start = (this.frame > 0 ? this.vert_indices[this.frame-1] : 0);
        var face_start = (this.frame > 0 ? this.face_indices[this.frame-1] : 0);

        var verts = this.verts.subarray(vert_start, vert_end);
        var colors = this.colors.subarray(vert_start, vert_end);
        var faces = this.faces.subarray(face_start, face_end);

        this.dynamicMesh.update(verts, colors, faces);
        return this
    }

    nextFrame(reset) {
        if (!this.all_frames_loaded) {
            throw('Attempting to set a frame not loaded.')
        }
        if (reset) {
            this.setFrame((this.frame+1)%this.num_frames);
        } else if (this.frame+1 < this.num_frames) {
            this.setFrame(this.frame+1);
        }
        return this
    }
}

class DynamicMesh {
    constructor(max_verts) {
        this.max_verts = max_verts
        this.geometry = new THREE.BufferGeometry()
        var positions = new Float32Array( max_verts * 3 );
        var colors = new Float32Array( max_verts * 3 );
        var indexes = new Uint32Array( max_verts * 6 );
        this.geometry.addAttribute( 'position', new THREE.BufferAttribute( positions, 3 ));
        this.geometry.addAttribute( 'color', new THREE.BufferAttribute( colors, 3 ));
        this.geometry.setIndex(new THREE.BufferAttribute( indexes, 1 ));

        var material = new THREE.MeshPhongMaterial( {
            vertexColors: THREE.VertexColors,
        } );

        this.mesh = new THREE.Mesh( this.geometry, material );
        this.mesh.castShadow = true;
        this.mesh.receiveShadow = true;
    }

    update(position, color, indices) {
        if (position.length > this.max_verts *3) {
            throw 'Position array too long', position.length
        }
        this.geometry.attributes.position.array.set(position);
        this.geometry.attributes.color.array.set(color);
        this.geometry.index.array.set(indices);
        this.geometry.index.array.fill(0, indices.length);// Fill rest with 0.
        this.geometry.setDrawRange(0, position.length*3);
        this.geometry.attributes.position.needsUpdate = true;
        this.geometry.attributes.color.needsUpdate = true;
        this.geometry.index.needsUpdate = true;
        this.geometry.computeVertexNormals();
        this.geometry.computeBoundingSphere();
    }
}
