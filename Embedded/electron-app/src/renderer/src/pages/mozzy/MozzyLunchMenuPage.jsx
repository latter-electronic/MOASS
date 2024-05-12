// pages/mozzy/MozzyLunchMenuPage.jsx
import React, { useEffect } from 'react'
import useLunchMenuStore from '../../stores/LunchMenuStore'
import BackButton from '../../assets/images/buttons/backward-arrow.png'

function LunchMenu() {
    const { lunchMenus } = useLunchMenuStore(state => ({
        lunchMenus: state.lunchMenus, 
    }))

    return (
        <div className="flex flex-col items-center justify-center p-1">
            <h1 className="text-2xl font-bold mb-6">오늘의 점심 메뉴</h1>
            <div className="flex overflow-x-auto bg-white rounded-lg scrollbar-hide shadow" style={{ maxHeight: '450px', maxWidth: '600px' }}>
                <div className="flex flex-row">
                    {lunchMenus.map((menu, index) => (
                        <div key={index} className="flex flex-col justify-between min-w-[600px] p-4">
                            <div className=''>
                                <h2 className="text-xl font-semibold">{index + 1}. {menu.fields[0].value}</h2>
                                <h2 className="text-xl font-semibold">{menu.fields[1].value}</h2>
                            </div>
                            <div className="flex justify-center items-center">
                                <img src={menu.image_url} alt={menu.fields[0].value} className="my-6 object-cover w-80"/>
                            </div>
                        </div>
                    ))}
                </div>
            </div>
        </div>
    )
}

export default LunchMenu

