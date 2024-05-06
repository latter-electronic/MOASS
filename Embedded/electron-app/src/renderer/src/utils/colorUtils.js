// utils/colorUtils.js
export function getEpicColorClasses(epicName) {
    const colorMap = {
        "[EM] IoT 기기 설계": { text: "text-jteal", bg: "bg-jtealB" },
        "[EM] 임베디드 공통": { text: "text-jgreen", bg: "bg-jgreenB" },
        "[공통] 회의": { text: "text-jgreen", bg: "bg-jgreenB" },
        "[공통] 팀 일정": { text: "text-jyellow", bg: "bg-jyellowB" },
        "[EM] 메인 화면": { text: "text-jteal", bg: "bg-jtealB" },
        "[EM] 알림 화면": { text: "text-jteal", bg: "bg-jtealB" },
        "[EM] 이음보드 페이지": { text: "text-jteal", bg: "bg-jtealB" },
        "[EM] Jira 페이지": { text: "text-jblue", bg: "bg-jblueB" },
        "[BE] API - Gitlab": { text: "text-jpurple", bg: "bg-jpurpleB" },
        "[공통] 프로젝트 설계": { text: "text-jpurple", bg: "bg-jpurpleB" },
        "[공통] 기타": { text: "text-jgray", bg: "bg-jgrayB" },
        "[EM] 좌석도 기능": { text: "text-jteal", bg: "bg-jtealB" }
    };

    const defaultColor = { text: "text-jpurple", bg: "bg-jpurpleB" };
    return colorMap[epicName] || defaultColor;
}
