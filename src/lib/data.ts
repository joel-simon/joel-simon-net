import type { Project } from '$lib/types'

export const labels = [
    'generative',
    'sculpture',
    'code',
    'lighting',
    'AI',
    'web',
    // 'tool'
    // 'video'
]

export const projects: Project[] = [
    {
        name: 'About',
        labels: [],
        img: 'imgs/lamp_me_square.jpg',
        year: undefined,
        hide: false,
        description: "Hi, I'm Joel",
        path: '/about'
    },
    {
        name: 'Ceramic Lamp 2',
        year: 2023,
        labels: ['lighting', 'sculpture'],
        img: 'imgs/thumbnails/ceramic-lamp-2.jpeg',
        description: 'Hand built ceramic lamp.'
    },
    {
        name: 'LatentScape',
        year: 2023,
        externalPath: 'https://latentscape.com',
        labels: ['web', 'code', 'AI'],
        img: 'imgs/thumbnails/latentscape.jpg',
        description: 'A virtual world for exploring and creating images with others.'
    },
    {
        name: 'New Words',
        year: 2023,
        path: 'new-words',
        labels: ['generative', 'code', "AI"],
        img: 'imgs/new-words/cover4.webp',
        description: 'Expanding the english language.'
    },
    {
        name: 'Ceramic Lamp 1',
        year: 2022,
        path: 'ceramic-lamp',
        labels: ['lighting', 'sculpture'],
        img: 'imgs/thumbnails/ceramic-lamp.jpg',
        description: 'Learning the process of slip casting.'
    },
    {
        name: 'GAN Portraits',
        year: 2021,
        labels: ['generative', 'code', 'AI'],
        img: 'imgs/thumbnails/gan-portrait.jpg',
        description: 'Generative face collages using machine learning.'
    },
    {
        name: 'Derivative Works',
        year: 2020,
        labels: ['generative', 'web', 'code', 'AI'],
        img: 'imgs/derivative-works-2.jpg',
        externalPath: 'https://derivative.works',
        description: 'Generative face collages using machine learning.'
    },
    {
        name: 'Generative Portraits',
        year: 2020,
        labels: ['generative', 'web', 'code'],
        img: 'imgs/evo-portraits/icon2.png',
        description: 'Generative faces using genetic algorithms.'
    },
    {
        name: 'Artbreeder Interviews',
        labels: ['generative', 'web', 'video'],
        img: 'imgs/ab_interviews_icon.png',
        year: 2020,
        hide: false,
        description:
            'Generative video of interviews with members of the Artbreeder community about how they are using machine learning and Artbreeder in their creative practices.'
    },
    {
        name: 'Forms Of Life',
        labels: ['generative', 'code'],
        img: 'imgs/forms-of-life/icon.png',
        year: 2020,
        hide: false,
        description: 'Experimental generative architecture for artificial life.'
    },
    {
        name: 'Antimander',
        labels: ['generative', 'code', 'web'],
        img: 'imgs/download.png',
        year: 2020,
        hide: false,
        externalPath: 'http://www.antimander.org',
        description:
            'A research paper, interactive blog and open-source library for fighting gerrymandering via generative methods.'
    },
    {
        name: 'Reaction Diffusion 3D',
        year: 2020,
        img: 'imgs/webgl-rd.png',
        labels: ['code', 'web'],
        externalPath: 'https://joels-share.s3.amazonaws.com/rd_shapes/index.html',
        description: 'View a 3D reaction diffusion simulation in the browser.'
    },
    {
        name: 'Table Lamp 4',
        labels: ['lighting'],
        img: 'imgs/table-lamp-4/icon.jpg',
        year: 2019,
        description: 'Table lamp.'
    },
    {
        name: 'Neural Tablets',
        labels: ['generative', 'sculpture', 'AI'],
        img: 'imgs/tablets/icon.png',
        path: '/tablets',
        year: 2019,
        hide: false,
        description: 'An extension of my Dimensions of Dialogue set in clay tablets.'
    },
    {
        name: 'Coral Video',
        labels: ['generative', 'code', 'video'],
        img: 'imgs/coral_video/icon.jpg',
        year: 2019,
        hide: false,
        description: 'A music video of my Corals project.'
    },
    {
        name: 'Morphogen Site',
        path: '/morphogen',
        labels: ['generative', 'code', 'web'],
        img: 'imgs/morphogen.jpg',
        year: 2019,
        hide: false,
        description: 'Website made in reaction diffusion shaders.'
    },
    {
        name: 'Dimensions of Dialogue',
        labels: ['generative', 'code', 'AI'],
        img: 'imgs/dod/binary_model_10.png',
        img2: 'imgs/dod/grid-3x3.jpg',
        year: 2018,
        hide: false,
        description:
            'Experiments inspired by early proto-writing systems such as cuneiform and hieroglyphs. Here, new writing systems are created by challenging two neural networks to communicate information via images'
    },
    {
        name: 'Ganbreeder',
        labels: ['generative', 'code', 'web', 'AI'],
        img: 'imgs/ganbreeder2.jpg',
        description: 'A website to breed images collaboratively.',
        year: 2018
    },
    {
        name: 'Desk Lamp 3',
        labels: ['lighting'],
        img: 'imgs/desk-lamp-3/icon2.jpg',
        year: 2018
    },
    {
        name: 'Corals',
        labels: ['generative', 'code'],
        img: 'imgs/corals/icon.jpg',
        year: 2018,
        description: 'Generative forms art-research'
    },
    {
        name: 'Ecosystem Modelling',
        labels: ['generative', 'code', 'video'],
        img: 'imgs/ecosystem-modelling/icon.jpg',
        description: 'Modelling ecosystem simulations',
        year: 2017
    },
    {
        name: 'Figuration',
        labels: ['video'],
        img: 'imgs/figuration.jpg',
        description: 'A si-fi short film made during the Imagine Science film festival.',
        year: 2017
    },
    {
        name: 'Plant Lamp',
        labels: ['lighting'],
        img: 'imgs/plant-lamp/icon.jpg',
        year: 2017,
        description: 'A growth lamp for my succulents.'
    },
    {
        name: 'Desk Lamp 2',
        labels: ['lighting'],
        img: 'imgs/desk-lamp-2/DSCF4329.jpg',
        year: 2017
    },
    {
        name: 'Evolving Floorplans',
        labels: ['generative', 'code'],
        img: 'imgs/evo_plans/icon.png',
        path: '/evo_floorplans',
        year: 2017,
        description: 'Floorplans optimized with a custom genetic algorithm.'
    },
    {
        name: 'Simon Lamps',
        labels: ['lighting', 'web', 'code'],
        img: 'imgs/simon-lamps/icon.jpg',
        year: 2016,
        description: 'A website for my lamps.'
    },
    {
        name: 'Desk Lamp 1',
        labels: ['lighting'],
        img: 'imgs/desk_lamp_1b/DSCF4294.jpg',
        year: 2016
    },
    {
        name: 'Wall Lamp',
        labels: ['lighting'],
        img: 'imgs/wall-lamp/wall-lamp-icon.jpg',
        year: 2016
    },
    {
        name: 'Sculpture Drop',
        labels: ['generative', 'sculpture'],
        img: 'imgs/sculpture-drop/icon.png',
        year: 2016,
        description:
            'Simulating the destruction of my sculptures by being dropped in a fracture simulation.'
    },
    {
        name: 'Table lamp 3',
        labels: ['lighting'],
        img: 'imgs/table-lamp-3/icon.jpg',
        year: 2015
    },

    {
        name: 'Tanya',
        labels: ['sculpture'],
        img: 'imgs/tanya/icon.png',
        year: 2015,
        description: 'Clay figure sculpture cast in plaster.'
    },
    {
        name: 'Table lamp 2',
        labels: ['lighting'],
        img: 'imgs/table-lamp-2/icon.jpg',
        year: 2015
    },
    {
        name: 'Facebook Graffiti',
        labels: ['code', 'web'],
        img: 'imgs/fb-graffiti.jpg',
        year: 2015,
        description: 'A collaborative anarchist art making chrome extension.'
    },

    {
        name: 'Scrap',
        labels: ['web', 'code'],
        img: 'imgs/scrap.png',
        year: 2015
    },
    {
        name: 'Slice',
        labels: ['generative', 'sculpture', 'code'],
        img: 'imgs/slice.jpg',
        year: 2014,
        description: 'Parametric geometric sculpture.'
    },
    {
        name: 'Graph Contraction',
        labels: ['generative', 'code', 'sculpture'],
        img: 'imgs/graph-contraction/graph-contraction.png',
        year: 2014,
        description: 'Graph contraction algorithms applied to 3D meshes.'
    },
    {
        name: 'Maria',
        labels: ['sculpture'],
        img: 'imgs/maria/icon2.png',
        year: 2013,
        description: 'A life size figure sculpture cast in plaster.'
    },
    {
        name: 'Image To Paint',
        labels: ['generative', 'code'],
        img: 'imgs/image-to-paint/icon.jpg',
        year: 2012,
        description: 'Software to convert an image to strokes.'
    },
    {
        name: 'Head in Hands',
        labels: ['sculpture'],
        img: 'imgs/head-in-hands/icon.JPG',
        year: 2012
    },
    {
        name: 'Cornered Hands',
        labels: ['sculpture'],
        img: 'imgs/cornered-hands/icon.jpg',
        year: 2012
    },
    {
        name: 'Small-talk Robot',
        labels: ['code'],
        img: 'imgs/smalltalk/smalltalk_square.jpg',
        year: 2012,
        description: 'A robot that will make small talk with the viewer.'
    },
    {
        name: 'Mosaic Table',
        labels: [],
        img: 'imgs/mosaic-table/table_square.jpg',
        year: 2007
    }
]