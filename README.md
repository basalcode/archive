# Archive - 트레이딩 복기 시스템

트레이딩 활동을 체계적으로 기록하고 분석하기 위한 복기 시스템입니다.

## 프로젝트 구조

### Prisma 스키마 구조

이 프로젝트는 Prisma의 멀티 파일 스키마 기능을 활용하여 도메인별로 스키마를 분리하여 관리합니다.

```
prisma/
├── main.prisma              # 데이터소스 및 제너레이터 설정
└── models/
    ├── enums.prisma         # 모든 enum 정의
    ├── account.prisma       # 계좌 및 거래소 관련 모델
    ├── journal.prisma       # 일지 구조 (Journal, JournalItem, JournalItemResource)
    ├── resource.prisma      # 자료 관리 (Resource)
    ├── note.prisma          # 외부 정보 (Note)
    ├── review.prisma        # 복기 관계 (Review)
    ├── overview.prisma      # 시장 분석 (Overview 및 하위 모델들)
    ├── principle.prisma     # 트레이딩 원칙 (Principle, PrincipleEvaluation)
    ├── reference.prisma     # 참조 데이터 (Symbol, StrategyMethod, Indicator)
    ├── risk.prisma          # 리스크 관리 (Preference, RiskManagement 등)
    ├── strategy.prisma      # 전략 정의 (Strategy, TradingStrategy)
    ├── scenario.prisma      # 시나리오 계획 (Scenario, EntryScenario, ExitScenario)
    ├── trading.prisma       # 매매 메타 정보 (Trading)
    └── order.prisma         # 주문 정보 (Order, OpenOrder, CloseOrder)
```

### 도메인별 분리 설명

#### **핵심 시스템**
- **enums.prisma**: 모든 열거형 타입 정의 (JournalItemType, CurrencyType, ScoreType 등)
- **account.prisma**: 거래소 및 계좌 관리 (Exchange, Account, Transaction)

#### **일지 및 자료 관리**
- **journal.prisma**: 일지 구조 (Journal, JournalItem, JournalItemResource)
- **resource.prisma**: 참고 자료 저장소 (Resource)
- **note.prisma**: 외부 정보 및 아이디어 기록 (Note)
- **review.prisma**: JournalItem 간 복기 관계 (Review)

#### **시장 분석**
- **overview.prisma**: 시장 분석 (Overview, ChartOverview, IndicatorOverview, MacroOverview, EventOverview)

#### **트레이딩 원칙**
- **principle.prisma**: 트레이딩 원칙 정의 및 평가 (Principle, PrincipleEvaluation)

#### **참조 데이터**
- **reference.prisma**: 참조 데이터 (Symbol, StrategyMethod, Indicator)

#### **리스크 관리**
- **risk.prisma**: 리스크 관리 (Preference, RiskManagement, PositionRiskManagement, AssetRiskManagement, AccountRiskManagement)

#### **전략 및 시나리오**
- **strategy.prisma**: 전략 정의 및 관찰 (Strategy, TradingStrategy)
- **scenario.prisma**: 시나리오 계획 (Scenario, EntryScenario, ExitScenario, ScenarioTradingStrategy)

#### **매매 및 주문**
- **trading.prisma**: 매매 메타 정보 (Trading)
- **order.prisma**: 주문 정보 (Order, OpenOrder, CloseOrder)

### 설계 원칙

1. **단일 책임 원칙**: 각 파일은 명확한 하나의 책임만 가짐
2. **논리적 그룹핑**: 관련 모델들이 적절히 분리됨
3. **확장성**: 새로운 기능 추가 시 적절한 파일에 배치하기 쉬움
4. **가독성**: 파일명만으로도 내용을 쉽게 파악 가능

## 개발 환경 설정

```bash
# 의존성 설치
npm install

# Prisma 클라이언트 생성
npx prisma generate

# 데이터베이스 마이그레이션
npx prisma migrate dev

# 개발 서버 실행
npm run dev
```

## 기술 스택

- **Framework**: Next.js 15
- **Database**: SQLite (Prisma ORM)
- **Language**: TypeScript
- **Styling**: Tailwind CSS
