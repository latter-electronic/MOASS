const statusStyles = {
    0: { message: '자리비움', bgColor: 'bg-amber-300' },
    1: { message: '착석중', bgColor: 'bg-emerald-500' },
    2: { message: '공가', bgColor: 'bg-rose-600' },
    3: { message: '방해금지', bgColor: 'bg-stone-400' },
  };
  
  export default function StatusComponent({ statusId }) {
    const { message, bgColor } = statusStyles[statusId] || statusStyles[0];
  
    return (
      <div className={`${bgColor} w-36 h-screen flex items-center justify-center`}>
        <span className="text-white text-6xl font-medium tracking-ww2 [writing-mode:vertical-lr]">
          {message}
        </span>
      </div>
    );
  }
  