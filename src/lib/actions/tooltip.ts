export function tooltip(element: HTMLElement): { destroy: () => void } {
  let div: HTMLDivElement | undefined;
  let title: string | null;

  function mouseOver(event: MouseEvent): void {
    // NOTE: remove the `title` attribute, to prevent showing the default browser tooltip
    // remember to set it back on `mouseleave`
    title = element.getAttribute("title");
    element.removeAttribute("title");

    div = document.createElement("div");
    div.textContent = title;
    div.style.cssText = `
			text-align: left;
			border: 1px solid #ddd;
			box-shadow: 1px 1px 1px #ddd;
			background: white;
			border-radius: 4px;
			padding: 4px;
			position: absolute;
			top: ${event.pageY + 5}px;
			left: ${event.pageX + 5}px;
		`;
    document.body.appendChild(div);
  }

  function mouseMove(event: MouseEvent): void {
    if (div) {
      div.style.left = `${event.pageX + 5}px`;
      div.style.top = `${event.pageY + 5}px`;
    }
  }

  function mouseLeave(): void {
    if (div) {
      document.body.removeChild(div);
    }
    // NOTE: restore the `title` attribute
    if (title) {
      element.setAttribute("title", title);
    }
  }

  element.addEventListener("mouseover", mouseOver);
  element.addEventListener("mouseleave", mouseLeave);
  element.addEventListener("mousemove", mouseMove);

  return {
    destroy() {
      element.removeEventListener("mouseover", mouseOver);
      element.removeEventListener("mouseleave", mouseLeave);
      element.removeEventListener("mousemove", mouseMove);
    },
  };
}
