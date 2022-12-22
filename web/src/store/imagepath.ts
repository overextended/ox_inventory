export let imagepath = 'images';

export function setImagePath(path: string) {
  if (path && path !== '') imagepath = path;
}

export const checkimage = (image: string) => {
  if(/^https:\/\/.+(\.png|\.apng)$/.test(image)) return image;
  return (`${imagepath}/${image}.png`);
}