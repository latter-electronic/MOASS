import BackIcon from '../../assets/images/buttons/backward-arrow.png'

export default function BackButton({ onClick }) {
    return (
        <button 
        onClick={onClick} 
        className='w-5' 
        aria-label="Back Button">
            <img src={BackIcon} alt="Back" style={{ width: '100%', height: 'auto' }} />
        </button>
    )
}