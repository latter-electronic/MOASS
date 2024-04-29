import React from 'react';
import tag_wave from '../../assets/tag_wave.svg';

export default function TagSuccess() {
    const backgroundStyle = {
        backgroundImage: `url(${tag_wave})`,
        backgroundSize: 'cover',
        backgroundPosition: 'center',
        width: '100%',
        height: '100vh',
      };

    return (
      <div style={backgroundStyle} className="flex flex-row justify-between h-dvh w-full">
          <div className="flex flex-1 justify-center items-center">
              <p>반갑습니다, 김싸피님!</p>
          </div>
      </div>
    )
  }
  