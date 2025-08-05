#!/bin/bash

# ash 버전 3.5.1부터 3.5.33까지 브랜치 생성 및 설정 스크립트

set -e  # 에러 발생시 스크립트 중단

# 현재 브랜치 저장
current_branch=$(git branch --show-current)

echo "현재 브랜치: $current_branch"
echo "ash 버전별 브랜치를 생성합니다..."

# 3.5.1부터 3.5.33까지 반복
for version in $(seq 1 33); do
    ash_version="3.5.$version"
    branch_name="ash-$ash_version"
    
    echo "=== 브랜치 $branch_name 생성 중 ==="
    
    # main 브랜치에서 새 브랜치 생성 (기존 브랜치가 있다면 삭제)
    git checkout main
    
    # 로컬 브랜치가 존재하면 삭제
    if git show-ref --verify --quiet refs/heads/"$branch_name"; then
        echo "기존 로컬 브랜치 $branch_name 삭제 중..."
        git branch -D "$branch_name"
    fi
    
    # 리모트 브랜치가 존재하면 삭제
    if git show-ref --verify --quiet refs/remotes/origin/"$branch_name"; then
        echo "기존 리모트 브랜치 origin/$branch_name 삭제 중..."
        git push origin --delete "$branch_name" || true
    fi
    
    git checkout -b "$branch_name"
    
    # mix.exs에서 ash 버전 수정
    perl -pi -e "s/{:ash, \"[^\"]*\"}/{:ash, \"$ash_version\"}/g" mix.exs
    
    echo "mix.exs에서 ash 버전을 $ash_version으로 수정했습니다."
    
    # mix.lock과 deps 디렉토리 삭제
    rm -f mix.lock
    rm -rf deps
    
    echo "mix.lock과 deps 디렉토리를 삭제했습니다."
    
    # 의존성 다운로드
    mix deps.get
    
    echo "의존성을 다운로드했습니다."
    
    # 변경사항 커밋
    git add .
    git commit -m "Update ash version to $ash_version"
    
    echo "변경사항을 커밋했습니다."
    
    # origin에 force push
    git push -f origin "$branch_name"
    
    echo "브랜치 $branch_name을 origin에 force push했습니다."
    echo ""
done

# 원래 브랜치로 돌아가기
git checkout "$current_branch"

echo "=== 모든 작업이 완료되었습니다! ==="
echo "생성된 브랜치들:"
for version in $(seq 1 33); do
    echo "  - ash-3.5.$version"
done