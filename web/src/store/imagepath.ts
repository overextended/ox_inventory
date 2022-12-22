export let imagepath = 'images';

export function setImagePath(path: string) {
  if (path && path !== '') imagepath = path;
}

export const checkimage = (item: any) => {
  let image = item.name;
  if(item.metadata?.image){
    image = item.metadata.image;
    if(/^https:\/\/.+(\.png|\.apng)$/.test(image)) return image;  
  }
  return (`${imagepath}/${image}.png`);
}