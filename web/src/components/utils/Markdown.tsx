import { marked } from 'marked';
import DOMPurify from 'dompurify';

interface Props extends React.HTMLAttributes<HTMLDivElement> {
  content: string;
}

const Markdown = ({ content, className }: Props) => {
  const html = DOMPurify.sanitize(marked.parse(content, { async: false }));

  return <div dangerouslySetInnerHTML={{ __html: html }} className={className} />;
};

export default Markdown;
