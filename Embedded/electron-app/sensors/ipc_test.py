import json
import time
import sys
import io

sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

count = 0
data = {
    'name': 'Electron과 Python 연동 test',
    'description': 'Electron에서 Python 스크립트를 실행하고, 그 결과를 React 컴포넌트로 전달하는 예시입니다.',
}


while True:
    time.sleep(20)
    data['count'] = count  # 루프의 각 반복에서 count 값을 업데이트
    json_data = json.dumps(data, ensure_ascii=False) # 유니코드 유지
    sys.stdout.write(json_data + '\n')  # '\n'을 추가하여 줄 바꿈 처리
    sys.stdout.flush()  # 즉시 출력
    print("Python TEST!!!!!!!!!!!!!!!!!!", file=sys.stderr)
    count += 1  # count 증가
