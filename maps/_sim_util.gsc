#include common_scripts\utility;
#include maps\_utility;
#include maps\_hud_util;

/*
 * Draw text to screen
 */
createText(font, fontScale, align, relative, x, y, sort, alpha, text, colour) {
    textElem = self createFontString(font, fontScale, self);
    textElem setPoint(align, relative, x, y);
    textElem.sort = sort;
    textElem.alpha = alpha;
    textElem.color = colour;
    textElem setText(text);

    return textElem;
}

/*
 * Draw rectangle to screen
 */
createRectangle(align, relative, x, y, width, height, color, shader, sort, alpha) {
    boxElem = newClientHudElem(self);
    boxElem.elemType = "bar";
    if (!level.splitScreen) {
        boxElem.x = -2;
        boxElem.y = -2;
    }
    boxElem.width = width;
    boxElem.height = height;
    boxElem.align = align;
    boxElem.relative = relative;
    boxElem.xOffset = 0;
    boxElem.yOffset = 0;
    boxElem.children = [];
    boxElem.sort = sort;
    boxElem.color = color;
    boxElem.alpha = alpha;
    boxElem.shader = shader;
    boxElem setParent(level.uiParent);
    boxElem setShader(shader, width, height);
    boxElem.hidden = false;
    boxElem setPoint(align, relative, x, y);

    return boxElem;
}

MIN(x, y) {
    if (x < y)
        return x;
    return y;
}

root_text_col() {
    return (53/255, 192/255, 252/255);
}

ops_text_col() {
    return (36/255, 227/255, 205/255);
}