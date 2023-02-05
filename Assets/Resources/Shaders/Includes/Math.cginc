float remap01(float a, float b, float t) {
	return (t - a) / (b - a);
}

float remap(float v, float minOld, float maxOld, float minNew, float maxNew) {
	return minNew + (v - minOld) * (maxNew - minNew) / (maxOld - minOld);
}

// Referenced from https://iquilezles.org/articles/functions/
// Power curve function is a generalized parabola function
// Allows both sides of the curve to be independently manipulated
float pcurve(float x, float a, float b)
{
	float k = pow(a + b, a + b) / (pow(a, a) * pow(b, b));
	return k * pow(x, a) * pow(1.0 - x, b);
}

// Referenced from https://www.shadertoy.com/view/Xd2yRd
// Takes a linear function and biases it to make higher outputs less common
float bias(float x, float bias)
{
    // Adjust input to make control feel more linear
    float k = pow(1 - bias, 3);
    return (x * k) / (x * k - x + 1);
}