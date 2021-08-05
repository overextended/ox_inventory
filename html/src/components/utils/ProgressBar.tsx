import { useState } from "react"
import useNuiEvent from "../../hooks/useNuiEvent"
import { debugData } from "../../utils/debugData"

debugData([
    {
      action: 'startProgress',
      data: {
        text: "Using Water",
        duration: 5000,
      }
    }
])

const ProgressBar: React.FC = () => {
    const [duration, setDuration] = useState<number>(0)
    const [isVisible, setVisible] = useState<boolean>(false)
    const [text, setText] = useState<string>('')

    useNuiEvent('startProgress', (data) => {

        setText(data.text)
        
        setDuration(data.duration)

        setVisible(true)
        
        setTimeout(() => {
            setVisible(false)
        }, data.duration)
    })

    // Shouldn't need with style in progress when using keyframe anim
    return (
        <div className="progbar-container" style={{visibility: isVisible ? 'visible' : 'hidden'}}>
            <div className="progress" style={{/*width: isVisible ? '100%' : '0%',*/ animation: isVisible ? `progbar ${duration}ms forwards` : ''}}> 
                <div className="progbar-text">
                    {text}
                </div>
            </div>
        </div>
    )
}

export default ProgressBar
