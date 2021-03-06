return lovr.graphics.newShader([[
out vec3 lightDirection;
out vec3 normalDirection;

vec4 position(mat4 projection, mat4 transform, vec4 vertex) {
  vec3 lightPosition = vec3(0., 10., 3.);

  vec4 vVertex = transform * vec4(lovrPosition, 1.);
  vec4 vLight = lovrView * vec4(lightPosition, 1.);

  lightDirection = normalize(vec3(vLight - vVertex));
  normalDirection = normalize(lovrNormalMatrix * lovrNormal);

  return projection * transform * vertex;
}
]], [[
in vec3 lightDirection;
in vec3 normalDirection;

vec4 color(vec4 graphicsColor, sampler2D image, vec2 uv) {
  vec3 cAmbient = vec3(.25);
  vec3 cDiffuse = vec3(.75);
  vec3 cSpecular = vec3(.35);

  float diffuse = max(dot(normalDirection, lightDirection), 0.);
  float specular = 0.;

  if (diffuse > 0.) {
    vec3 r = reflect(lightDirection, normalDirection);
    vec3 viewDirection = normalize(-vec3(gl_FragCoord));

    float specularAngle = max(dot(r, viewDirection), 0.);
    specular = pow(specularAngle, 5.);
  }

  vec3 cFinal = pow(clamp(vec3(diffuse) * cDiffuse + vec3(specular) * cSpecular, cAmbient, vec3(1.)), vec3(.4545));
  return vec4(cFinal, 1.) * lovrDiffuseColor * graphicsColor * texture(image, uv);
}
]])
