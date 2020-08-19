
Promise.all([
    imageLoad('imgs/forms-of-life/seed_1.png')
]).then(([ seed_img ]) => {
    const gol = new GOlViewer(seed_img)
    gol.moveTo(document.querySelector('.gol-container'))
    gol.start()
    const containers = document.querySelectorAll('.gol-container')
    for (const cont of containers) {
        cont.onclick = () => {
            if (gol.container == cont) {
                gol.reset()
            } else {
                gol.moveTo(cont)
            }
        }
    }
    window.onscroll = () => {
        let min_y = 999999999
        let active_cont = null

        for (const cont of containers) {
            let y = cont.offsetTop - window.scrollY + cont.clientHeight*.25
            if (y > 0 && y < min_y) {
                min_y = y
                active_cont = cont
            }
        }
        if (gol.container != active_cont) {
            gol.moveTo(active_cont)
        }
    }
})
