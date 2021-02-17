import QtQuick 2.6
ShaderEffect {
    height: width
    mesh: Qt.size(Math.max(16, width / 3), 2)
    property real value
    property real borderWidth
    property color backgroundColor
    property color valueColor
    readonly property real centerPx: width/2
    readonly property vector2d dimensions: Qt.vector2d(centerPx, borderWidth)
    vertexShader: "
        const highp float TwoPies = 6.28318530717958647;
        attribute highp vec4 qt_Vertex;
        attribute highp vec2 qt_MultiTexCoord0;
        varying lowp float circularXPosition;
        uniform highp mat4 qt_Matrix;
        uniform highp vec2 dimensions;
        void main() {
            circularXPosition = qt_MultiTexCoord0.x;
            lowp float circumfenceArg = TwoPies * circularXPosition;
            vec2 mappedToCircle = dimensions.xx
                + vec2(sin(circumfenceArg), cos(circumfenceArg))// * -1.0
                * mix(dimensions.x, dimensions.x - dimensions.y, qt_MultiTexCoord0.y);
            gl_Position = qt_Matrix * vec4(mappedToCircle, 0, 1);
        }
    "
    fragmentShader: "
        uniform lowp float qt_Opacity;
        uniform lowp float value;
        uniform lowp vec4 backgroundColor;
        uniform lowp vec4 valueColor;
        varying lowp float circularXPosition;
        const lowp float threshold = 0.5;
        void main() {
            if (circularXPosition < threshold)
                gl_FragColor = mix(valueColor, backgroundColor, step(circularXPosition*2.0, value))
                    * qt_Opacity;
            else
                gl_FragColor = mix(valueColor, backgroundColor, step(2.0-(circularXPosition*2.0),value))
                    * qt_Opacity;

        }
    "
}
