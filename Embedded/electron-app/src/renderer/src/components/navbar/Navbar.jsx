import React, { useState, useEffect, useRef } from 'react'
import { NavLink, useNavigate } from 'react-router-dom'
import { deviceLogout } from '../../services/deviceService'
import { fetchUserInfo, updateUserStatus } from '../../services/userService.js'
import useUIStore from '../../stores/UIStore.js'
import AuthStore from '../../stores/AuthStore.js'; 
import useGlobalStore from '../../stores/useGlobalStore.js'
import { useFloating, useClick, useDismiss, useRole, useListNavigation, useInteractions, FloatingFocusManager, useTypeahead, offset, flip, size, autoUpdate, FloatingPortal } from '@floating-ui/react';

import mainIcon from './navbar_icon_main.svg'
import mainIcon_w from './navbar_icon_main_white.svg'
import boardIcon from './navbar_icon_board.svg'
import boardIcon_w from './navbar_icon_board_white.svg'
import jiraIcon from './navbar_icon_jira.svg'
import jiraIcon_w from './navbar_icon_jira_white.svg'
import alertIcon from './navbar_icon_alert.svg'
import alertIcon_w from './navbar_icon_alert_white.svg'
import testProfileImg from './profileImageTest.jpg'

export default function Navbar() {
  const navigate = useNavigate()

  const { activeTab, setActiveTab } = useUIStore() // 네브바 선택 아이콘
  const [users, setUsers] = useState([]) // 사용자 데이터 저장할곳
  const { logout, deviceId, cardSerialId } = AuthStore((state) => ({
    logout: state.logout,
    deviceId: state.deviceId,
    cardSerialId: state.cardSerial,
  }))
  const [isOpen, setIsOpen] = useState(false)
  const [activeIndex, setActiveIndex] = useState(null)
  const [selectedIndex, setSelectedIndex] = useState(null)
  const statusOptions = [ '자리비움', '착석중', '공가', '방해금지']
  const { accessToken, refreshToken } = AuthStore.getState()

  const { user, setUser } = useGlobalStore(state => ({
    user: state.user,
    setUser: state.setUser
  }))

  const backgroundColors = {
    착석중: 'bg-emerald-500',
    자리비움: 'bg-amber-300',
    공가: 'bg-rose-600',
    방해금지: 'bg-stone-400'
  }

  const backgroundColor =
    selectedIndex !== null ? backgroundColors[statusOptions[selectedIndex]] : 'bg-emerald-500' // 초기 초록색으로 시작하게해놓음. 나중에 수정

  const { refs, floatingStyles, context } = useFloating({
    placement: 'left-start',
    open: isOpen,
    onOpenChange: setIsOpen,
    whileElementsMounted: autoUpdate,
    middleware: [
      offset(5),
      flip({ padding: 10 }),
      size({
        apply({ rects, elements, availableHeight }) {
          Object.assign(elements.floating.style, {
            maxHeight: `${availableHeight}px`,
            minWidth: `${rects.reference.width}px`
          })
        },
        padding: 10
      })
    ]
  })

  const click = useClick(context, { event: 'mousedown' })
  const dismiss = useDismiss(context)
  const role = useRole(context, { role: 'listbox' })
  const listContentRef = useRef(statusOptions)

  const listRef = useRef(statusOptions.map(() => null))
  const isTypingRef = useRef(false)
  const listNav = useListNavigation(context, {
    listRef,
    activeIndex,
    selectedIndex,
    onNavigate: setActiveIndex,
    loop: true
  })
  const typeahead = useTypeahead(context, {
    listRef: listContentRef,
    activeIndex,
    selectedIndex,
    onMatch: isOpen ? setActiveIndex : setSelectedIndex,
    onTypingChange(isTyping) {
      isTypingRef.current = isTyping
    }
  })

  const { getReferenceProps, getFloatingProps, getItemProps } = useInteractions([
    useDismiss(context),
    useRole(context, { role: 'listbox' }),
    useListNavigation(context, {
      listRef: useRef(statusOptions.map(() => null)),
      activeIndex,
      selectedIndex,
      onNavigate: setActiveIndex,
      loop: true
    }),
    useTypeahead(context, {
      listRef: useRef(statusOptions),
      activeIndex,
      selectedIndex,
      onMatch: isOpen ? setActiveIndex : setSelectedIndex,
      onTypingChange: (isTyping) => {}
    }),
    useClick(context, { event: 'mousedown' })
  ])

  useEffect(() => {
    setUser();
  }, [setUser]);

  const handleSelect = async (index) => {
    setSelectedIndex(index);
    setIsOpen(false);
    // 상태 업데이트 로직
    try {
      const updateData = { statusId: index.toString() };
      const response = await updateUserStatus(updateData);
      console.log('Status update response:', response);
    } catch (error) {
      console.error('Error updating user status:', error);
      alert('Failed to update status');
    }
  };

  const selectedItemLabel = selectedIndex !== null ? statusOptions[selectedIndex] : '상태를 선택하세요';

  useEffect(() => {
    const loadUsers = async () => {
      try {
        if (!accessToken) {
          setUsers(null)
        } else{
        const userData = await fetchUserInfo();
        setUsers(userData.data.data); // API 호출 결과를 상태에 저장
        if (userData.data.data.statusId !== undefined) {
          setSelectedIndex(userData.data.data.statusId); // Set selectedIndex based on statusId
        }
      }
      } catch (error) {
        console.error('사용자 데이터를 불러오는 중 오류가 발생했습니다:', error);
      }
    };

    loadUsers();
  }, []);

  const callLoginFunction = () => {
    navigate(`/login`)
  }

  const ipcLogoutHandle = () => window.electron.ipcRenderer.send('logout-success', 'logout')

  const handleLogout = async () => {
    try {
      const logoutData = {
        deviceId: deviceId, // deviceId 나중에 실제로 가져오기
        userId: cardSerialId // userId 나중에 실제로 가져오기
      }
      await deviceLogout(logoutData)
      logout()  // store 상태 변경
      ipcLogoutHandle() // python에 ipc로 전달
      alert('로그아웃 성공!')

      navigate('/login')
    } catch (error) {
      console.error('로그아웃 실패:', error)
      alert('로그아웃 중 에러 발생')
    }
  }

  const callTestLogin = () => {
    navigate(`/tagsuccess`)
  }

  const callSSETest = () => {
    navigate(`/ssetest`)
  }

  const callNameplateTest = () => {
    navigate(`/nameplate`)
  }

  return (
    <nav className="flex flex-col justify-between w-navbarWidth h-screen bg-gray-800 text-white p-4 ">
      <div className="flex flex-col items-center">
        <div
          tabIndex={0}
          ref={refs.setReference}
          aria-labelledby="select-label"
          aria-autocomplete="none"
          className={`mt-2 relative flex justify-center items-center size-20 rounded-full ${backgroundColor}`}
          {...getReferenceProps()}
        >
          <img
            src={user?.profileImg || testProfileImg} // 사용자 프로필 이미지 사용
            alt={selectedItemLabel || 'Select...'}
            className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 w-16 rounded-full"
          />
        </div>
      </div>
      <div className="flex flex-col items-center gap-3">
        <NavLink
          to="/"
          onClick={() => setActiveTab('/')}
          className={activeTab === '/' ? '' : 'opacity-50'}
        >
          <img
            src={activeTab === '/' ? mainIcon : mainIcon_w}
            alt="Main"
            className="p-2 hover:bg-gray-700 rounded size-24"
          />
        </NavLink>
        <NavLink
          to="/board"
          onClick={() => setActiveTab('/board')}
          className={activeTab === '/board' ? '' : 'opacity-50'}
        >
          <img
            src={activeTab === '/board' ? boardIcon : boardIcon_w}
            alt="Board"
            className="p-2 hover:bg-gray-700 rounded size-24"
          />
        </NavLink>
        <NavLink
          to="/jira"
          onClick={() => setActiveTab('/jira')}
          className={activeTab === '/jira' ? '' : 'opacity-50'}
        >
          <img
            src={activeTab === '/jira' ? jiraIcon : jiraIcon_w}
            alt="Jira"
            className="p-2 hover:bg-gray-700 rounded size-24"
          />
        </NavLink>
        <NavLink
          to="/alert"
          onClick={() => setActiveTab('/alert')}
          className={activeTab === '/alert' ? '' : 'opacity-50'}
        >
          <img
            src={activeTab === '/alert' ? alertIcon : alertIcon_w}
            alt="Alert"
            className="p-2 hover:bg-gray-700 rounded size-24"
          />
        </NavLink>
      </div>
      {isOpen && (
        <FloatingPortal>
          <FloatingFocusManager context={context} modal={false}>
            <div
              ref={refs.setFloating}
              style={{
                ...floatingStyles,
                overflowY: 'auto',
                background: '#fff',
                minWidth: 100,
                borderRadius: 8,
                outline: 0
              }}
              {...getFloatingProps()}
            >
              {statusOptions.map((value, i) => (
                <div
                  key={value}
                  ref={(node) => {
                    listRef.current[i] = node
                  }}
                  role="option"
                  tabIndex={i === activeIndex ? 0 : -1}
                  aria-selected={i === selectedIndex && i === activeIndex}
                  style={{
                    display: 'flex',
                    justifyContent: 'space-between',
                    alignItems: 'center',
                    padding: '10px 20px', // Padding을 좌우로 증가시켜 주어 좀 더 넓은 간격을 제공
                    cursor: 'default',
                    color: '#000',
                    background: i === activeIndex ? 'gainsboro' : ''
                  }}
                  {...getItemProps({
                    onClick() {
                      handleSelect(i)
                    },
                    onKeyDown(event) {
                      if (event.key === 'Enter') {
                        event.preventDefault()
                        handleSelect(i)
                      }
                      if (event.key === ' ' && !isTypingRef.current) {
                        event.preventDefault()
                        handleSelect(i)
                      }
                    }
                  })}
                >
                  <span style={{ display: 'flex', alignItems: 'center' }}>
                    {' '}
                    {/* 상태 원과 텍스트를 함께 묶어 정렬 */}
                    <span // 상태 색상을 나타내는 원
                      className={`h-2.5 w-2.5 rounded-full mr-4 ${backgroundColors[value]}`}
                    ></span>
                    {value}
                  </span>
                  <span
                    aria-hidden
                    style={{
                      marginLeft: '20px' // 체크 마크와 옵션명 사이의 간격을 추가
                    }}
                  >
                    {i === selectedIndex ? ' ✓' : ''}
                  </span>
                </div>
              ))}
              <hr className="mt-4 mb-2 bg-gray-300 h-1 border-none" />
              <span className="text-indigo-950 font-bold ml-3">개발용</span>
              <div className="flex flex-col justify-around mt-2">
                <button
                  className="bg-blue-500 hover:bg-blue-700 text-white font-bold py-2 px-4 rounded"
                  onClick={() => callLoginFunction()}
                >
                  로그인
                </button>
                <button
                  className="bg-teal-500 hover:bg-teal-700 text-white font-bold py-2 px-4 rounded"
                  onClick={() => callTestLogin()}
                >
                  로그인(SSE용)
                </button>
                <button
                  className="bg-red-500 hover:bg-red-700 text-white font-bold py-2 px-4 rounded"
                  onClick={handleLogout}
                >
                  로그아웃
                </button>
                <button
                  className="bg-yellow-500 hover:bg-yellow-700 text-white font-bold py-2 px-4 rounded"
                  onClick={callSSETest}
                >
                  SSE 테스트
                </button>
                <button
                  className="bg-purple-500 hover:bg-purple-700 text-white font-bold py-2 px-4 rounded"
                  onClick={callNameplateTest}
                >
                  명패
                </button>
              </div>
            </div>
          </FloatingFocusManager>
        </FloatingPortal>
      )}
    </nav>
  )
}
