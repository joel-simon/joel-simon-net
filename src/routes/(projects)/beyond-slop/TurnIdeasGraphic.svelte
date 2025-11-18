<div class="graphic-container">
  <div class="main-content my-16">
    <div class="red-x">
      <div class="x-bar x-bar-1"></div>
      <div class="x-bar x-bar-2"></div>
    </div>

    <h1 class="main-quote">
      "Turn your <span class="strikethrough">ideas</span> into reality!"
    </h1>
  </div>

  <div class="statements">
    <div class="statement">
      <p>Prompting can only express what has already been defined</p>
    </div>
    <div class="statement">
      <p>
        Novel works unfold through a creative process not a priori articulable
      </p>
    </div>
    <div class="statement">
      <p class="!text-center">
        Materiality is an empowering way of non verbal thinking
      </p>
    </div>
  </div>
</div>

<style>
  .graphic-container {
    width: 100%;
    max-width: 1400px;
    /* margin: 0 auto; */
    padding: 40px 20px;
    background: white;
    font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Arial,
      sans-serif;
  }

  .main-content {
    position: relative;
    text-align: center !important;
    margin-bottom: 60px;
    /* min-height: 350px; */
    display: flex;
    align-items: center;
    justify-content: center;
  }

  .red-x {
    position: absolute;
    width: 175px;
    height: 175px;
    top: 50%;
    left: 50%;
    transform: translate(-50%, -50%);
    z-index: 1;
  }

  .x-bar {
    position: absolute;
    background: #d94843;
    top: 50%;
    left: 50%;
  }

  .x-bar-1 {
    width: 100%;
    height: 40px;
    transform: translate(-50%, -50%) rotate(45deg);
  }

  .x-bar-2 {
    width: 100%;
    height: 40px;
    transform: translate(-50%, -50%) rotate(-45deg);
  }

  .main-quote {
    position: relative;
    z-index: 2;
    font-size: 48px;
    font-weight: 400;
    font-style: italic;
    line-height: 1.3;
    margin: 0;
    padding: 0 40px;
    color: #000;
    max-width: 1000px;
  }

  .strikethrough {
    position: relative;
    font-style: italic;
  }

  .statements {
    display: flex;
    justify-content: space-between;
    gap: 60px;
    margin-top: 40px;
  }

  .statement {
    flex: 1;
  }

  .statement p {
    font-size: 22px;
    line-height: 1.5;
    font-weight: 300;
    margin: 0;
    color: #000;
    text-align: center !important;
  }

  @media (max-width: 1024px) {
    .main-quote {
      font-size: 38px;
    }

    .red-x {
      width: 350px;
      height: 350px;
    }

    .x-bar-1,
    .x-bar-2 {
      height: 80px;
    }

    .statement p {
      font-size: 18px;
    }

    .statements {
      gap: 40px;
    }
  }

  @media (max-width: 768px) {
    .graphic-container {
      padding: 30px 15px;
    }

    .main-quote {
      font-size: 28px;
    }

    .red-x {
      width: 250px;
      height: 250px;
    }

    .x-bar-1,
    .x-bar-2 {
      height: 60px;
    }

    .statements {
      flex-direction: column;
      gap: 25px;
    }

    .statement p {
      font-size: 16px;
    }
  }
</style>
