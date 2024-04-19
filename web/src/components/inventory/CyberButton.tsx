import React from 'react';
import styles from './CyberButton.module.css';

interface CyberButtonProps {
  containerStyles?: React.CSSProperties;
  contentStyles?: React.CSSProperties;
  children?: React.ReactNode;
  className?: string;
}

const CyberButton: React.FC<CyberButtonProps> = ({ containerStyles, contentStyles, children, className }) => {
  return (
    <div style={containerStyles} className={`${styles.container} ${className}`}>
      <div style={contentStyles} className={styles.content}>
        {children}
      </div>
    </div>
  );
};

export default CyberButton;
