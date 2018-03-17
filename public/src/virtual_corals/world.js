// (function(){

var renderer, scene, camera;
var mouse;
var line;
var MAX_POINTS = 15000;
var drawCount;
var click_objects = [];

var show_3d = true;
var container, stats;
var camera, scene, renderer;
var particleSystem;
var particles;
var laoder;
window.corals = [];
var particle_material;
var world
var max_coral_distance = Infinity;

window.world = world
// variables referenced by main script.
window.webgl_world_init = init;
window.webgl_world_initiated = false;
window.webgl_show = false;
window.webgl_world_add_coral = add_coral;


var coral_options = ['2F64_g488','B3DN_g111', 'H2ED_g362', 'KX43_g91',
                     'NG08_g307_pca',  'WJBI_g44', '53F2_g216', 'C0JH_g62',
                     'IV74_g85', 'LEXL_g100', 'NJFG_g183', 'Y0KA_g50',
                      '9QEM_g430', 'CJNT_g48', 'J2PQ_g320', 'NG08_g307', 'P8QV_g101'];

function remove(array, element) {
    var index = array.indexOf(element);

    if (index !== -1) {
        array.splice(index, 1);
    }
}

function init_particles() {
    var particleCount = 500;
    particles = new THREE.Geometry()
    particle_velocities = [];

    // create the particle variables
    var pMaterial = new THREE.ParticleBasicMaterial({
        color: 0xFFFFFF,
        size: 1,
        map: THREE.ImageUtils.loadTexture(
            "coral_data/circle.png"
        ),
        blending: THREE.AdditiveBlending,
        transparent: true
    });

    for (var p = 0; p < particleCount; p++) {
        var pX = (Math.random()-0.5) * 120,
            pY = (Math.random() * 120) + 1,
            pZ = (Math.random()-0.5) * 120;
        var particle = new THREE.Vector3(pX, pY, pZ);
        var velocity = new THREE.Vector3((Math.random()-0.5) * .01, (Math.random()-0.5) * .01, (Math.random()-0.5) * .01);
        particle.velocity = velocity
        particles.vertices.push(particle);
    }

    // create the particle system
    particleSystem = new THREE.Points(particles, pMaterial);
    particleSystem.sortParticles = true;
    scene.add(particleSystem);
}

// var foo = 0;
// function load_coral(path, x=0, z=0, ry = 0) {
//     return new Promise(function(resolve, reject) {
//         var coral = new CoralAnimationViewer(path);
//         coral.loadLastFrame().then(() => {
//             // var x = points[foo][0]*120;
//             // var z = points[foo++][1]*120;
//             // console.log(points[foo]);
//             coral.setPosition(x, 0, z).setRotation(0, ry, 0).addToScene(scene);
//             resolve(coral)
//         }).catch(reject)
//     })
// }

function init() {
    container = document.getElementById('webgl_container');

    // CAMERA
    var aspect = $(container).width() / $(container).height()
    camera = new THREE.PerspectiveCamera( 35, aspect, 1, 3500 );
    camera.position.z = 2750/50;
    camera.zoom = 1;
    camera.position.y = 10;
    camera.updateProjectionMatrix();

    // SCENE
    scene = new THREE.Scene();
    // scene.background = new THREE.Color( 0x050505 );
    scene.background = new THREE.Color(0x111111);
    scene.fog = new THREE.Fog(  0x3f7b9d, 0, 200 );

    // RENDERER
    renderer = new THREE.WebGLRenderer( { antialias: true } );
    renderer.setPixelRatio( window.devicePixelRatio );
    renderer.setSize($(container).width(), $(container).height());
    renderer.gammaInput = true;
    renderer.gammaOutput = true;
    renderer.setClearColor( 0xffffff, 1);
    renderer.shadowMap.enabled = true;
    renderer.context.getShaderInfoLog = function () { return '' };
    container.appendChild( renderer.domElement );

    // STATS
    stats = new Stats();
    container.appendChild( stats.dom );

    // CONTROLS
    controls = new THREE.OrbitControls( camera, renderer.domElement );
    controls.minDistance = 1;
    controls.maxDistance = 75;
    controls.maxPolarAngle = Math.PI/2.2;
    // controls.autoRotate = true;
    // controls.autoRotateSpeed = 0.5;
    controls.enableZoom = false;
    // controls.enableKeys = false;
    // controls.enablePan = false;
    controls.target.y = 2;

    // LIGHTS
    var light1 = new THREE.DirectionalLight( 0xaaaaaa, .25 );
    light1.position.set( 0, 10, 2 );
    light1.castShadow = true;
    light1.shadow.mapSize.width = 2048;
    light1.shadow.mapSize.height = 2048;

    light1.shadow.camera.left = -50;
    light1.shadow.camera.bottom = -50;
    light1.shadow.camera.right = 50;
    light1.shadow.camera.top = 50;

    scene.add( light1 );

    scene.add(new THREE.HemisphereLight(0xFFFFFF, 1.0))

    init_particles();

    loader = new THREE.JSONLoader();

    loader.load( 'coral_data/half_sphere_smooth4.js', function(geometry) {
        var groundMaterial = new THREE.MeshPhongMaterial( {
            color: 0xaaaaaa,
            wireframe:false,
            reflectivity:0.5
        });
        world = new THREE.Mesh( geometry, groundMaterial );
        world.material.side = THREE.BackSide;
        world.scale.x = 150;
        world.scale.y = 150;
        world.scale.z = 150;
        world.receiveShadow = true;
        window.world = world
        var s;
        var verts = world.geometry.vertices;
        for (var i = 0; i < verts.length; i++) {
            s = Math.sqrt(verts[i].x**2 + verts[i].y**2 + verts[i].y**2);
            if (s > .5) {
                verts[i].x += Math.random() * .2 * s;
                verts[i].y += Math.random() * .2 * s;
                verts[i].z += Math.random() * .2 * s;
            } else {
                verts[i].x += Math.random() * .005 * s;
                verts[i].y += Math.random() * .005 * s;
                verts[i].z += Math.random() * .005 * s;
            }
        }
        scene.add(world)
    })
    raycaster = new THREE.Raycaster();
    mouse = new THREE.Vector2();

    animate()
    window.addEventListener( 'resize', onResize, false );
    container.addEventListener( 'keydown', onKeyDown, false );
    container.addEventListener( 'mousemove', onMouseMove, false );
    $(container).click(onMouseDown);

    $('.controls.zoom-in').on('click touchend', function(event) {
        camera.zoom *= 1.2;
        camera.updateProjectionMatrix();
        event.stopPropagation();
    })

    $('.controls.zoom-out').on('click touchend', function(event) {
        if (camera.zoom * 0.8 > .4) {
            camera.zoom *= 0.8;
            camera.updateProjectionMatrix();
            event.stopPropagation();
        }
    })

    $('.controls.add_coral p').on('click touchend', function(event) {

        $(this).text('Add Another Coral')

        if (coral_options.length == 0) {
            alert('Can\'t add more corals.');
            return;
        }
        var id = coral_options[Math.floor(Math.random() * coral_options.length)];
        remove(coral_options, id);
        add_coral('coral_data/coral/'+id+'/');
        event.stopPropagation();
    })

    $('.controls.maximize').on('click touchend', function() {
        if ($(container).hasClass('text_body')) {
            $(container).removeClass('text_body');
        } else {
            $(container).addClass('text_body');
        }
        onResize()
    })
//     add_coral('coral_data/coral/CJNT_g48/')
}

function new_coral_position(coral) {
    coral.dynamicMesh.geometry.computeBoundingBox();
    var box = coral.dynamicMesh.geometry.boundingBox.clone();

    var n_tries = 20;
    var neighbor;
    var r, a, found_collision;
    // var sphere = coral.dynamicMesh.geometry.boundingSphere;
    var valid_positions = [ ];
    var valid_position_distances = [];


    console.log(box);

    if (corals.length == 0) {
        max_coral_distance = Math.sqrt( box.max.x*box.max.x + box.max.z*box.max.z )*2;
        return new THREE.Vector3(0, 0, 0);
    }

    for (var i = 0; i < n_tries; i++) {
        var p = new THREE.Vector3(0, 0, 0);
        a = Math.random() * 2*Math.PI;
        p.x += Math.cos(a) * Math.random() * max_coral_distance*1.5;
        p.z += Math.sin(a) * Math.random() * max_coral_distance*1.5;

        if (p.length() > 0.6 * 150) { // Outside world bounds.
            continue;
        }

        found_collision = false;
        for (var j = 0; j < corals.length; j++) {
            var box2 = corals[j].dynamicMesh.geometry.boundingBox.clone();
            box2.translate(corals[j].getPosition())

            if (box.clone().translate(p).intersectsBox(box2)) {
                found_collision = true;
                break;
            }
        }
        if (!found_collision) {
            valid_positions.push(p);
            valid_position_distances.push(p.length());
            // var min_distance = Infinity;
            // var min_y = null;
            // var d
            // for (var i = 0; i < world.geometry.vertices.length; i++) {
            //     d = p.distanceTo(world.geometry.vertices[i]);

            //     if (d < min_distance) {
            //         min_distance = d;
            //         min_y = world.geometry.vertices[i].y
            //     }
            // }
            // // console.log(min_distance, min_y);
            // p.y = min_y
            // max_coral_distance = Math.max(max_coral_distance, p.length());
            // console.log(max_coral_distance);
            // return p;
        }

    }
    if (valid_positions.length == 0) {
        return null
    }
    var i = valid_position_distances.indexOf(Math.min(...valid_position_distances));
    var p2 = valid_positions[i];
    max_coral_distance = Math.max(max_coral_distance, p2.length());
    return p2;

    // return null;
}

function add_coral(path) {
    return new Promise(function(resolve, reject) {
        var coral = new CoralAnimationViewer(path);
        coral.loadAllFrames().then(() => {
            var p = new_coral_position(coral);


            if (!p) {
                return reject('Cannot add coral to reef.')
            }
            coral.setFrame(0);
            coral.setPosition(p.x, p.y, p.z);
            // coral.setRotation(0, Math.random()*2*Math.PI, 0);
            click_objects.push(coral.dynamicMesh.mesh);
            coral.addToScene(scene)
            corals.push(coral);
            resolve(coral);
        }).catch(reject)
    })

    // load_coral('coral_data/coral/2F64_g488/', 0, 0).then(function(result){
    //     // corals = result;
    //     for (var i = 0; i < result.length; i++) {
    //         corals.push(result[i]);
    //         corals[i].addToScene(scene)
    //         click_objects.push(corals[i].dynamicMesh.mesh)
    //     }
    //     console.log('test');
    //     animate();
    //     for (var i = 0; i < elements.length; i++) {
    //     expression
    // }
    // }).catch((err) => console.log(err))
}


function onMouseMove(event) {
    var coral = getCoralUnderMouse(event);
    if (coral) {
        $(container).css('cursor','pointer');
    } else {
        $(container).css('cursor','move');
    }
}


function onResize() {
    var width = $(container).width();
    var height = $(container).height();

    camera.aspect = width / height;
    camera.updateProjectionMatrix();
    renderer.setSize( width, height );
}

function animate() {
    requestAnimationFrame( animate );
    if (window.webgl_show) {
        update();
        render();
        stats.update();
        controls.update();
    }
}

var last_update = 0
var need_reset = false;

function onKeyDown(event) {
    var keyCode = event.which;
    var r_key = 82;
    var space_key = 32;
    if (keyCode == r_key) {
        need_reset = true;
    }
};

function getCoralUnderMouse( event ) {
    mouse.x = ( event.offsetX / renderer.domElement.clientWidth ) * 2 - 1;
    mouse.y = - ( event.offsetY / renderer.domElement.clientHeight ) * 2 + 1;

    raycaster.setFromCamera( mouse, camera );

    // console.time('intersectObjects');
    var intersects = raycaster.intersectObjects( click_objects );
    // console.timeEnd('intersectObjects');
    var i;

    if ( intersects.length > 0 ) {
        i = click_objects.indexOf(intersects[ 0 ].object);
        return corals[i];
    } else {
        return null;
    }
}

function onMouseDown( event ) {
    event.preventDefault();
    var coral = getCoralUnderMouse(event);

    if (coral) {
        if (!coral.all_frames_loaded) {
            coral.loadAllFrames();
        } else {
            coral.setFrame( 0 );
        }
    } else {

    }
}

// function onMouseHold( event ) {
//     var coral = getCoralUnderMouse(event);

//     if (coral) {
//         controls.target = coral.getPosition().clone();
//         controls.target.y += 2;
//     }
// }

function update() {
    var d = Date.now()
    if (need_reset) {
        for (var i = 0; i < corals.length; i++) {
            if (corals[i].all_frames_loaded) {
                corals[i].setFrame(0);
            }
        }
        need_reset = false
    } else if (d - last_update > 50) {
        for (var i = 0; i < corals.length; i++) {
            if (corals[i].all_frames_loaded) {
                corals[i].nextFrame(false)
            }
        }
        last_update = d;
    }

    for (var i = 0; i < particles.vertices.length; i++) {
        var particle = particles.vertices[i];
        particle.add(particle.velocity);
        if (particle.x < 0) {
            particle.x == 100;
        } else if (particle.x > 100) {
            particle.x = 0;
        }
        if (particle.y < 1) {
            particle.y == 100;
        } else if (particle.y > 100) {
            particle.y = 0;
        }
        if (particle.z < 0) {
            particle.z == 100;
        } else if (particle.z > 100) {
            particle.z = 0;
        }
    }
    particleSystem.geometry.verticesNeedUpdate = true;
}

function render() {
    renderer.render( scene, camera );
}

// })();