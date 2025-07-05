-- CreateEnum
CREATE TYPE "CurrencyType" AS ENUM ('USDT', 'USDC', 'KRW');

-- CreateEnum
CREATE TYPE "PositionDirectionType" AS ENUM ('Long', 'Short');

-- CreateEnum
CREATE TYPE "MarketTrendType" AS ENUM ('VeryBullish', 'Bullish', 'Crabish', 'Bearish', 'VeryBearish');

-- CreateEnum
CREATE TYPE "ScoreType" AS ENUM ('VeryHigh', 'High', 'Medium', 'Low', 'VeryLow');

-- CreateEnum
CREATE TYPE "TimeIntervalType" AS ENUM ('OneMinute', 'TwoMinutes', 'ThreeMinutes', 'FiveMinutes', 'TenMinutes', 'FifteenMinutes', 'ThirtyMinutes', 'FortyFiveMinutes', 'OneHour', 'TwoHours', 'ThreeHours', 'FourHours', 'TwelveHours', 'OneDay', 'OneWeek', 'OneMonth', 'ThreeMonths', 'SixMonths', 'TwelveMonths');

-- CreateEnum
CREATE TYPE "TradeTimeFrameType" AS ENUM ('Scalp', 'Day', 'Swing', 'Position', 'Investment');

-- CreateEnum
CREATE TYPE "StrategyBiasType" AS ENUM ('FollowTrend', 'CounterTrend');

-- CreateEnum
CREATE TYPE "OrderType" AS ENUM ('Open', 'Close');

-- CreateEnum
CREATE TYPE "ResourceType" AS ENUM ('Image', 'Video', 'Audio', 'Document');

-- CreateEnum
CREATE TYPE "ScenarioType" AS ENUM ('Entry', 'Exit');

-- CreateEnum
CREATE TYPE "TransactionType" AS ENUM ('Deposit', 'Withdrawal', 'Order');

-- CreateEnum
CREATE TYPE "NoteType" AS ENUM ('Book', 'Web', 'Idea');

-- CreateEnum
CREATE TYPE "PreferenceType" AS ENUM ('Strategy', 'RiskManagement', 'Principle');

-- CreateTable
CREATE TABLE "Exchange" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Exchange_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Account" (
    "id" SERIAL NOT NULL,
    "exchange_id" INTEGER NOT NULL,
    "name" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "currency" "CurrencyType" NOT NULL DEFAULT 'USDT',
    "is_virtual" BOOLEAN NOT NULL DEFAULT false,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Account_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Transaction" (
    "id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "order_id" INTEGER NOT NULL,
    "type" "TransactionType" NOT NULL,
    "amount" TEXT NOT NULL,
    "reserved_funds" TEXT NOT NULL,
    "available_balance" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Transaction_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Journal" (
    "id" SERIAL NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "content" TEXT NOT NULL DEFAULT '',
    "highlight" "ScoreType" NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Journal_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JournalResource" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "resource_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "JournalResource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Resource" (
    "id" SERIAL NOT NULL,
    "type" "ResourceType" NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "memo" TEXT NOT NULL DEFAULT '',
    "uri" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "Resource_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Note" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "type" "NoteType" NOT NULL,
    "source" TEXT NOT NULL DEFAULT '',
    "reason" TEXT NOT NULL DEFAULT '',
    "thought" TEXT NOT NULL DEFAULT '',
    "action_plan" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "Note_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Trade" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "symbol_id" INTEGER NOT NULL,
    "execution_score" "ScoreType" NOT NULL,
    "realized_pnl" TEXT NOT NULL DEFAULT '0',
    "total_quantity" TEXT NOT NULL DEFAULT '0',
    "avg_entry_price" TEXT NOT NULL DEFAULT '0',
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Trade_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Position" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "symbol_id" INTEGER NOT NULL,
    "execution_score" "ScoreType" NOT NULL,
    "realized_pnl" TEXT NOT NULL DEFAULT '0',

    CONSTRAINT "Position_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Order" (
    "id" SERIAL NOT NULL,
    "account_id" INTEGER NOT NULL,
    "symbol_id" INTEGER NOT NULL,
    "type" "OrderType" NOT NULL,
    "direction" "PositionDirectionType" NOT NULL,
    "price" TEXT NOT NULL,
    "quantity" TEXT NOT NULL,
    "leverage" DECIMAL(5,2) NOT NULL,
    "fee" TEXT NOT NULL,
    "executed_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Order_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "OpenOrder" (
    "id" SERIAL NOT NULL,
    "order_id" INTEGER,
    "position_id" INTEGER NOT NULL,
    "trade_id" INTEGER NOT NULL,
    "unclosed_quantity" TEXT NOT NULL,
    "entry_scenario_id" INTEGER NOT NULL,

    CONSTRAINT "OpenOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "CloseOrder" (
    "id" SERIAL NOT NULL,
    "order_id" INTEGER NOT NULL,
    "position_id" INTEGER NOT NULL,
    "trade_id" INTEGER NOT NULL,
    "pnl" TEXT NOT NULL,
    "realized_return_rate" DECIMAL(5,4) NOT NULL,
    "exit_scenario_id" INTEGER NOT NULL,

    CONSTRAINT "CloseOrder_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Symbol" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Symbol_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StrategyMethod" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "StrategyMethod_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Indicator" (
    "id" SERIAL NOT NULL,
    "name" TEXT NOT NULL,
    "full_name" TEXT NOT NULL,
    "description" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "Indicator_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "JournalReview" (
    "id" SERIAL NOT NULL,
    "date" TIMESTAMP(3) NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "highlight" "ScoreType" NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "review_purpose" TEXT NOT NULL DEFAULT '',
    "decision" TEXT NOT NULL DEFAULT '',
    "decision_reason" TEXT NOT NULL DEFAULT '',
    "result" TEXT NOT NULL DEFAULT '',
    "evaluation_score" "ScoreType" NOT NULL,
    "evaluation" TEXT NOT NULL DEFAULT '',
    "lesson" TEXT NOT NULL DEFAULT '',
    "action_plan" TEXT NOT NULL DEFAULT '',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "deactivated_at" TIMESTAMP(3),

    CONSTRAINT "JournalReview_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Preference" (
    "id" SERIAL NOT NULL,
    "type" "PreferenceType" NOT NULL,
    "title" TEXT NOT NULL DEFAULT '',
    "description" TEXT NOT NULL DEFAULT '',
    "importance" "ScoreType" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "Preference_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "RiskManagementPolicy" (
    "id" SERIAL NOT NULL,
    "preference_id" INTEGER NOT NULL,
    "tradeRiskRate" DECIMAL(5,4) NOT NULL,
    "tradeMarginRate" DECIMAL(5,4) NOT NULL,
    "totalMarginLimitRate" DECIMAL(5,4) NOT NULL,
    "marginLossLimitRate" DECIMAL(5,4) NOT NULL,

    CONSTRAINT "RiskManagementPolicy_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PortfolioRiskManagement" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "PortfolioRiskManagement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "AccountRiskManagement" (
    "id" SERIAL NOT NULL,
    "portfolio_risk_management_id" INTEGER NOT NULL,
    "risk_management_policy_id" INTEGER NOT NULL,
    "account_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "AccountRiskManagement_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PrincipleDefinition" (
    "id" SERIAL NOT NULL,
    "preference_id" INTEGER NOT NULL,
    "evaluation_criteria" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PrincipleDefinition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "PrincipleEvaluation" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "principle_definition_id" INTEGER NOT NULL,
    "score" "ScoreType" NOT NULL,
    "score_reason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "PrincipleEvaluation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StrategyDefinition" (
    "id" SERIAL NOT NULL,
    "preference_id" INTEGER NOT NULL,
    "method_id" INTEGER NOT NULL,
    "score" "ScoreType" NOT NULL,
    "score_reason" TEXT NOT NULL DEFAULT '',

    CONSTRAINT "StrategyDefinition_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "StrategyObservation" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "strategy_definition_id" INTEGER NOT NULL,
    "bias" "StrategyBiasType" NOT NULL,
    "symbol_id" INTEGER NOT NULL,
    "interval" "TimeIntervalType" NOT NULL,
    "market_trend" "MarketTrendType" NOT NULL,
    "min_liquidity_price" TEXT NOT NULL,
    "max_liquidity_price" TEXT NOT NULL,

    CONSTRAINT "StrategyObservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Scenario" (
    "id" SERIAL NOT NULL,
    "journal_id" INTEGER NOT NULL,
    "symbol_id" INTEGER NOT NULL,
    "confidence_score" "ScoreType" NOT NULL,
    "validity_score" "ScoreType" NOT NULL,
    "is_valid" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Scenario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EntryScenario" (
    "id" SERIAL NOT NULL,
    "scenario_group_id" INTEGER NOT NULL,
    "strategy_bias_type" "StrategyBiasType" NOT NULL,
    "time_frame" "TradeTimeFrameType" NOT NULL,
    "direction" "PositionDirectionType" NOT NULL,
    "target_entry_price" TEXT NOT NULL,
    "max_stop_loss_price" TEXT NOT NULL,
    "min_take_profit_price" TEXT NOT NULL,
    "first_take_profit_weight" DECIMAL(5,4) NOT NULL,
    "min_risk_reward_weight" DECIMAL(5,4) NOT NULL,
    "max_invalidation_price" TEXT NOT NULL,
    "min_invalidation_price" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "EntryScenario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExitScenario" (
    "id" SERIAL NOT NULL,
    "entry_scenario_id" INTEGER NOT NULL,
    "strategy_bias_type" "StrategyBiasType" NOT NULL,
    "stop_loss_price" TEXT NOT NULL,
    "stop_loss_weight" DECIMAL(5,4) NOT NULL,
    "take_profit_price" TEXT NOT NULL,
    "take_profit_weight" DECIMAL(5,4) NOT NULL,

    CONSTRAINT "ExitScenario_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "EntryScenarioStrategyObservation" (
    "id" SERIAL NOT NULL,
    "entry_scenario_id" INTEGER NOT NULL,
    "strategy_observation_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "EntryScenarioStrategyObservation_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "ExitScenarioStrategyObservation" (
    "id" SERIAL NOT NULL,
    "exit_scenario_id" INTEGER NOT NULL,
    "strategy_observation_id" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ExitScenarioStrategyObservation_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "Exchange_name_key" ON "Exchange"("name");

-- CreateIndex
CREATE INDEX "Exchange_created_at_idx" ON "Exchange"("created_at");

-- CreateIndex
CREATE INDEX "Exchange_deactivated_at_idx" ON "Exchange"("deactivated_at");

-- CreateIndex
CREATE INDEX "Account_exchange_id_idx" ON "Account"("exchange_id");

-- CreateIndex
CREATE INDEX "Account_created_at_idx" ON "Account"("created_at");

-- CreateIndex
CREATE INDEX "Account_deactivated_at_idx" ON "Account"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "Transaction_order_id_key" ON "Transaction"("order_id");

-- CreateIndex
CREATE INDEX "Transaction_account_id_idx" ON "Transaction"("account_id");

-- CreateIndex
CREATE INDEX "Transaction_order_id_idx" ON "Transaction"("order_id");

-- CreateIndex
CREATE INDEX "Transaction_type_idx" ON "Transaction"("type");

-- CreateIndex
CREATE INDEX "Transaction_created_at_idx" ON "Transaction"("created_at");

-- CreateIndex
CREATE INDEX "Transaction_deactivated_at_idx" ON "Transaction"("deactivated_at");

-- CreateIndex
CREATE INDEX "Journal_date_idx" ON "Journal"("date");

-- CreateIndex
CREATE INDEX "Journal_highlight_idx" ON "Journal"("highlight");

-- CreateIndex
CREATE INDEX "Journal_created_at_idx" ON "Journal"("created_at");

-- CreateIndex
CREATE INDEX "Journal_deactivated_at_idx" ON "Journal"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "JournalResource_journal_id_key" ON "JournalResource"("journal_id");

-- CreateIndex
CREATE INDEX "JournalResource_journal_id_idx" ON "JournalResource"("journal_id");

-- CreateIndex
CREATE INDEX "JournalResource_resource_id_idx" ON "JournalResource"("resource_id");

-- CreateIndex
CREATE INDEX "JournalResource_created_at_idx" ON "JournalResource"("created_at");

-- CreateIndex
CREATE INDEX "Resource_type_idx" ON "Resource"("type");

-- CreateIndex
CREATE INDEX "Resource_created_at_idx" ON "Resource"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "Note_journal_id_key" ON "Note"("journal_id");

-- CreateIndex
CREATE INDEX "Note_type_idx" ON "Note"("type");

-- CreateIndex
CREATE UNIQUE INDEX "Trade_journal_id_key" ON "Trade"("journal_id");

-- CreateIndex
CREATE INDEX "Trade_journal_id_idx" ON "Trade"("journal_id");

-- CreateIndex
CREATE INDEX "Trade_symbol_id_idx" ON "Trade"("symbol_id");

-- CreateIndex
CREATE INDEX "Trade_is_active_idx" ON "Trade"("is_active");

-- CreateIndex
CREATE INDEX "Trade_created_at_idx" ON "Trade"("created_at");

-- CreateIndex
CREATE UNIQUE INDEX "Position_journal_id_key" ON "Position"("journal_id");

-- CreateIndex
CREATE INDEX "Position_symbol_id_idx" ON "Position"("symbol_id");

-- CreateIndex
CREATE INDEX "Position_execution_score_idx" ON "Position"("execution_score");

-- CreateIndex
CREATE INDEX "Order_account_id_idx" ON "Order"("account_id");

-- CreateIndex
CREATE INDEX "Order_symbol_id_idx" ON "Order"("symbol_id");

-- CreateIndex
CREATE INDEX "Order_type_idx" ON "Order"("type");

-- CreateIndex
CREATE INDEX "Order_created_at_idx" ON "Order"("created_at");

-- CreateIndex
CREATE INDEX "Order_deactivated_at_idx" ON "Order"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "OpenOrder_order_id_key" ON "OpenOrder"("order_id");

-- CreateIndex
CREATE UNIQUE INDEX "OpenOrder_position_id_key" ON "OpenOrder"("position_id");

-- CreateIndex
CREATE INDEX "OpenOrder_entry_scenario_id_idx" ON "OpenOrder"("entry_scenario_id");

-- CreateIndex
CREATE INDEX "OpenOrder_trade_id_idx" ON "OpenOrder"("trade_id");

-- CreateIndex
CREATE UNIQUE INDEX "CloseOrder_order_id_key" ON "CloseOrder"("order_id");

-- CreateIndex
CREATE INDEX "CloseOrder_position_id_idx" ON "CloseOrder"("position_id");

-- CreateIndex
CREATE INDEX "CloseOrder_exit_scenario_id_idx" ON "CloseOrder"("exit_scenario_id");

-- CreateIndex
CREATE INDEX "CloseOrder_trade_id_idx" ON "CloseOrder"("trade_id");

-- CreateIndex
CREATE UNIQUE INDEX "Symbol_name_key" ON "Symbol"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Symbol_full_name_key" ON "Symbol"("full_name");

-- CreateIndex
CREATE INDEX "Symbol_created_at_idx" ON "Symbol"("created_at");

-- CreateIndex
CREATE INDEX "Symbol_deactivated_at_idx" ON "Symbol"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "StrategyMethod_name_key" ON "StrategyMethod"("name");

-- CreateIndex
CREATE INDEX "StrategyMethod_created_at_idx" ON "StrategyMethod"("created_at");

-- CreateIndex
CREATE INDEX "StrategyMethod_deactivated_at_idx" ON "StrategyMethod"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "Indicator_name_key" ON "Indicator"("name");

-- CreateIndex
CREATE UNIQUE INDEX "Indicator_full_name_key" ON "Indicator"("full_name");

-- CreateIndex
CREATE INDEX "Indicator_created_at_idx" ON "Indicator"("created_at");

-- CreateIndex
CREATE INDEX "Indicator_deactivated_at_idx" ON "Indicator"("deactivated_at");

-- CreateIndex
CREATE UNIQUE INDEX "JournalReview_journal_id_key" ON "JournalReview"("journal_id");

-- CreateIndex
CREATE INDEX "JournalReview_date_idx" ON "JournalReview"("date");

-- CreateIndex
CREATE INDEX "JournalReview_highlight_idx" ON "JournalReview"("highlight");

-- CreateIndex
CREATE INDEX "JournalReview_journal_id_idx" ON "JournalReview"("journal_id");

-- CreateIndex
CREATE INDEX "JournalReview_evaluation_score_idx" ON "JournalReview"("evaluation_score");

-- CreateIndex
CREATE INDEX "JournalReview_created_at_idx" ON "JournalReview"("created_at");

-- CreateIndex
CREATE INDEX "JournalReview_deactivated_at_idx" ON "JournalReview"("deactivated_at");

-- CreateIndex
CREATE INDEX "Preference_type_idx" ON "Preference"("type");

-- CreateIndex
CREATE INDEX "Preference_is_active_idx" ON "Preference"("is_active");

-- CreateIndex
CREATE INDEX "Preference_created_at_idx" ON "Preference"("created_at");

-- CreateIndex
CREATE INDEX "RiskManagementPolicy_preference_id_idx" ON "RiskManagementPolicy"("preference_id");

-- CreateIndex
CREATE UNIQUE INDEX "PortfolioRiskManagement_journal_id_key" ON "PortfolioRiskManagement"("journal_id");

-- CreateIndex
CREATE INDEX "PortfolioRiskManagement_created_at_idx" ON "PortfolioRiskManagement"("created_at");

-- CreateIndex
CREATE INDEX "AccountRiskManagement_portfolio_risk_management_id_idx" ON "AccountRiskManagement"("portfolio_risk_management_id");

-- CreateIndex
CREATE INDEX "AccountRiskManagement_account_id_idx" ON "AccountRiskManagement"("account_id");

-- CreateIndex
CREATE INDEX "AccountRiskManagement_risk_management_policy_id_idx" ON "AccountRiskManagement"("risk_management_policy_id");

-- CreateIndex
CREATE INDEX "PrincipleDefinition_preference_id_idx" ON "PrincipleDefinition"("preference_id");

-- CreateIndex
CREATE UNIQUE INDEX "PrincipleEvaluation_journal_id_key" ON "PrincipleEvaluation"("journal_id");

-- CreateIndex
CREATE INDEX "PrincipleEvaluation_principle_definition_id_idx" ON "PrincipleEvaluation"("principle_definition_id");

-- CreateIndex
CREATE INDEX "PrincipleEvaluation_score_idx" ON "PrincipleEvaluation"("score");

-- CreateIndex
CREATE INDEX "StrategyDefinition_preference_id_idx" ON "StrategyDefinition"("preference_id");

-- CreateIndex
CREATE INDEX "StrategyDefinition_method_id_idx" ON "StrategyDefinition"("method_id");

-- CreateIndex
CREATE INDEX "StrategyDefinition_score_idx" ON "StrategyDefinition"("score");

-- CreateIndex
CREATE UNIQUE INDEX "StrategyObservation_journal_id_key" ON "StrategyObservation"("journal_id");

-- CreateIndex
CREATE INDEX "StrategyObservation_strategy_definition_id_idx" ON "StrategyObservation"("strategy_definition_id");

-- CreateIndex
CREATE INDEX "StrategyObservation_symbol_id_idx" ON "StrategyObservation"("symbol_id");

-- CreateIndex
CREATE INDEX "StrategyObservation_interval_idx" ON "StrategyObservation"("interval");

-- CreateIndex
CREATE UNIQUE INDEX "Scenario_journal_id_key" ON "Scenario"("journal_id");

-- CreateIndex
CREATE INDEX "Scenario_is_valid_idx" ON "Scenario"("is_valid");

-- CreateIndex
CREATE INDEX "EntryScenario_is_active_idx" ON "EntryScenario"("is_active");

-- CreateIndex
CREATE INDEX "EntryScenario_scenario_group_id_idx" ON "EntryScenario"("scenario_group_id");

-- CreateIndex
CREATE INDEX "EntryScenarioStrategyObservation_created_at_idx" ON "EntryScenarioStrategyObservation"("created_at");

-- CreateIndex
CREATE INDEX "ExitScenarioStrategyObservation_created_at_idx" ON "ExitScenarioStrategyObservation"("created_at");

-- AddForeignKey
ALTER TABLE "Account" ADD CONSTRAINT "Account_exchange_id_fkey" FOREIGN KEY ("exchange_id") REFERENCES "Exchange"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Transaction" ADD CONSTRAINT "Transaction_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalResource" ADD CONSTRAINT "JournalResource_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalResource" ADD CONSTRAINT "JournalResource_resource_id_fkey" FOREIGN KEY ("resource_id") REFERENCES "Resource"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Note" ADD CONSTRAINT "Note_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Trade" ADD CONSTRAINT "Trade_symbol_id_fkey" FOREIGN KEY ("symbol_id") REFERENCES "Symbol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Position" ADD CONSTRAINT "Position_symbol_id_fkey" FOREIGN KEY ("symbol_id") REFERENCES "Symbol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Order" ADD CONSTRAINT "Order_symbol_id_fkey" FOREIGN KEY ("symbol_id") REFERENCES "Symbol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OpenOrder" ADD CONSTRAINT "OpenOrder_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "Order"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OpenOrder" ADD CONSTRAINT "OpenOrder_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OpenOrder" ADD CONSTRAINT "OpenOrder_trade_id_fkey" FOREIGN KEY ("trade_id") REFERENCES "Trade"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "OpenOrder" ADD CONSTRAINT "OpenOrder_entry_scenario_id_fkey" FOREIGN KEY ("entry_scenario_id") REFERENCES "EntryScenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CloseOrder" ADD CONSTRAINT "CloseOrder_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "Order"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CloseOrder" ADD CONSTRAINT "CloseOrder_position_id_fkey" FOREIGN KEY ("position_id") REFERENCES "Position"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CloseOrder" ADD CONSTRAINT "CloseOrder_trade_id_fkey" FOREIGN KEY ("trade_id") REFERENCES "Trade"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "CloseOrder" ADD CONSTRAINT "CloseOrder_exit_scenario_id_fkey" FOREIGN KEY ("exit_scenario_id") REFERENCES "ExitScenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "JournalReview" ADD CONSTRAINT "JournalReview_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "RiskManagementPolicy" ADD CONSTRAINT "RiskManagementPolicy_preference_id_fkey" FOREIGN KEY ("preference_id") REFERENCES "Preference"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PortfolioRiskManagement" ADD CONSTRAINT "PortfolioRiskManagement_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountRiskManagement" ADD CONSTRAINT "AccountRiskManagement_portfolio_risk_management_id_fkey" FOREIGN KEY ("portfolio_risk_management_id") REFERENCES "PortfolioRiskManagement"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountRiskManagement" ADD CONSTRAINT "AccountRiskManagement_account_id_fkey" FOREIGN KEY ("account_id") REFERENCES "Account"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "AccountRiskManagement" ADD CONSTRAINT "AccountRiskManagement_risk_management_policy_id_fkey" FOREIGN KEY ("risk_management_policy_id") REFERENCES "RiskManagementPolicy"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrincipleDefinition" ADD CONSTRAINT "PrincipleDefinition_preference_id_fkey" FOREIGN KEY ("preference_id") REFERENCES "Preference"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrincipleEvaluation" ADD CONSTRAINT "PrincipleEvaluation_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "PrincipleEvaluation" ADD CONSTRAINT "PrincipleEvaluation_principle_definition_id_fkey" FOREIGN KEY ("principle_definition_id") REFERENCES "PrincipleDefinition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StrategyDefinition" ADD CONSTRAINT "StrategyDefinition_preference_id_fkey" FOREIGN KEY ("preference_id") REFERENCES "Preference"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StrategyDefinition" ADD CONSTRAINT "StrategyDefinition_method_id_fkey" FOREIGN KEY ("method_id") REFERENCES "StrategyMethod"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StrategyObservation" ADD CONSTRAINT "StrategyObservation_strategy_definition_id_fkey" FOREIGN KEY ("strategy_definition_id") REFERENCES "StrategyDefinition"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StrategyObservation" ADD CONSTRAINT "StrategyObservation_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "StrategyObservation" ADD CONSTRAINT "StrategyObservation_symbol_id_fkey" FOREIGN KEY ("symbol_id") REFERENCES "Symbol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scenario" ADD CONSTRAINT "Scenario_journal_id_fkey" FOREIGN KEY ("journal_id") REFERENCES "Journal"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Scenario" ADD CONSTRAINT "Scenario_symbol_id_fkey" FOREIGN KEY ("symbol_id") REFERENCES "Symbol"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EntryScenario" ADD CONSTRAINT "EntryScenario_scenario_group_id_fkey" FOREIGN KEY ("scenario_group_id") REFERENCES "Scenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExitScenario" ADD CONSTRAINT "ExitScenario_entry_scenario_id_fkey" FOREIGN KEY ("entry_scenario_id") REFERENCES "EntryScenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EntryScenarioStrategyObservation" ADD CONSTRAINT "EntryScenarioStrategyObservation_entry_scenario_id_fkey" FOREIGN KEY ("entry_scenario_id") REFERENCES "EntryScenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "EntryScenarioStrategyObservation" ADD CONSTRAINT "EntryScenarioStrategyObservation_strategy_observation_id_fkey" FOREIGN KEY ("strategy_observation_id") REFERENCES "StrategyObservation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExitScenarioStrategyObservation" ADD CONSTRAINT "ExitScenarioStrategyObservation_exit_scenario_id_fkey" FOREIGN KEY ("exit_scenario_id") REFERENCES "ExitScenario"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "ExitScenarioStrategyObservation" ADD CONSTRAINT "ExitScenarioStrategyObservation_strategy_observation_id_fkey" FOREIGN KEY ("strategy_observation_id") REFERENCES "StrategyObservation"("id") ON DELETE RESTRICT ON UPDATE CASCADE;
