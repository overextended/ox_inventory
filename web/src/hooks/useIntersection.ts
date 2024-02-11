// https://github.com/mantinedev/mantine/blob/master/packages/%40mantine/hooks/src/use-intersection/use-intersection.ts

import { useCallback, useRef, useState } from 'react';

export function useIntersection<T extends HTMLElement = any>(
  options?: ConstructorParameters<typeof IntersectionObserver>[1]
) {
  const [entry, setEntry] = useState<IntersectionObserverEntry | null>(null);

  const observer = useRef<IntersectionObserver | null>(null);

  const ref = useCallback(
    (element: T | null) => {
      if (observer.current) {
        observer.current.disconnect();
        observer.current = null;
      }

      if (element === null) {
        setEntry(null);
        return;
      }

      observer.current = new IntersectionObserver(([_entry]) => {
        setEntry(_entry);
      }, options);

      observer.current.observe(element);
    },
    [options?.rootMargin, options?.root, options?.threshold]
  );

  return { ref, entry };
}
