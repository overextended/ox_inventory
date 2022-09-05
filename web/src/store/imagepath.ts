export let imagepath = 'images';

export function setImagePath(path: string) {
  if (path && path !== '') imagepath = path;
}
