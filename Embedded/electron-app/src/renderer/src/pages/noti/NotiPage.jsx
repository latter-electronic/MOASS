import { useEffect, useState } from 'react';
import { SwipeableList, SwipeableListItem, TrailingActions, SwipeAction } from 'react-swipeable-list';
import 'react-swipeable-list/dist/styles.css';

import { readAllNotifications, getRecentNotifications } from '../../services/notiService';
import useNotiStore from '../../stores/notiStore';
import NotiMM from './NotiMMComponent.jsx';
import NotiDetailComponent from './NotiDetailComponent.jsx'; // 상세 페이지 컴포넌트 임포트
import NotiSsafy from './NotiSsafyComponent.jsx';

import checkIcon from './testImg/check-icon.svg';
import mozzySleep from './testImg/mozzy-sleep.svg';

export default function NotiPage() {
  const notices = useNotiStore(state => state.notifications);
  const clearNotifications = useNotiStore(state => state.clearNotifications);
  const addNotifications = useNotiStore(state => state.addNotifications);
  const [selectedNotice, setSelectedNotice] = useState(null); // 선택된 알림 상태

  useEffect(() => {
    loadRecentNotifications();
  }, []);

  const handleClearAll = async () => {
    try {
      await readAllNotifications();
      clearNotifications();
    } catch (error) {
      console.error('Failed to clear all notifications:', error);
    }
  };

  const loadRecentNotifications = async () => {
    try {
      const response = await getRecentNotifications();
      const sortedNotifications = response.data.notifications.sort((a, b) => new Date(b.date) - new Date(a.date));
      addNotifications(sortedNotifications);
    } catch (error) {
      console.error('Failed to load recent notifications:', error);
    }
  };

  const trailingActions = (id) => (
    <TrailingActions>
      <SwipeAction
        destructive={true}
        onClick={() => handleDelete(id)}
      >
        <div className="text-red-600">Delete</div>
      </SwipeAction>
    </TrailingActions>
  );

  const handleDelete = (id) => {
    clearNotifications(notices.filter(noti => noti.notificationId !== id));
  };

  return (
    <div className="flex h-screen">
      <div className="w-1/3 bg-navy p-6 flex flex-col">
        <div className="flex justify-between items-center mb-4">
          <h1 className="text-4xl font-medium text-white">알림 모아쓰</h1>
          <button className="flex items-center gap-2 mt-3" onClick={handleClearAll}>
            <img src={checkIcon} alt="Check Icon" className="w-6 h-6" />
            <span className="text-lg text-white">모두 읽음 처리</span>
          </button>
        </div>
        <div className="flex-grow overflow-auto mt-4 scrollbar-hide">
          <SwipeableList className="scrollbar-hide">
            {notices.map((notice) => {
              const key = notice.notificationId;
              if (notice.source === 'mattermost') {
                return (
                  <SwipeableListItem
                    key={key}
                    trailingActions={trailingActions(notice.notificationId)}
                    onClick={() => setSelectedNotice(notice)} // 클릭 시 선택된 알림 설정
                  >
                    <NotiMM notice={notice} />
                  </SwipeableListItem>
                );
              }
              return (
                <SwipeableListItem
                  key={key}
                  trailingActions={trailingActions(notice.notificationId)}
                >
                  <NotiSsafy notice={notice} />
                </SwipeableListItem>
              );
            })}
          </SwipeableList>
        </div>
      </div>
      <div className="flex flex-col w-2/3 bg-gray-800/50 justify-center text-center items-center">
        {selectedNotice ? (
          <NotiDetailComponent notice={selectedNotice} onClose={() => setSelectedNotice(null)} /> // 선택된 알림의 상세 페이지 표시
        ) : (
          <div className="mb-4">
            <img src={mozzySleep} alt="모찌잠" className="ml-16 size-80 opacity-50" />
            <span className="text-2xl text-primary/60">현재는 고정된 알림이 없어요</span>
          </div>
        )}
      </div>
    </div>
  );
}
