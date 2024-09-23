// SPDX-License-Identifier: MIT

pragma solidity >=0.8.2 <0.9.0;

// Интерфейс контракта Forta, через который мы будем поднимать алерты
interface IForta {
    function raiseAlert(address user) external;
}

// Наш бот для обнаружения угроз
contract DetectionBot {
    IForta public forta;
    address public vaultAddress;  // адрес CryptoVault

    constructor(address _forta, address _vaultAddress) {
        forta = IForta(_forta);  // инициализируем контракт Forta
        vaultAddress = _vaultAddress;  // указываем адрес контракта CryptoVault
    }

    // Эта функция будет вызываться, когда транзакция проходит через мониторинг
    function handleTransaction(address from, bytes calldata data) external {
        // Проверяем, вызвана ли функция sweepToken
        bytes4 functionSignature = bytes4(data[:4]);  // берем первые 4 байта (это сигнатура функции)
        if (functionSignature == bytes4(keccak256("delegateTransfer(address,uint256,address)"))) {
            // Если функция delegateTransfer была вызвана, анализируем данные
            address to;
            uint256 value;
            address origSender;

            // Используем assembly для получения параметров функции delegateTransfer
            assembly {
                to := calldataload(4)       // Адрес получателя
                value := calldataload(36)   // Сумма перевода
                origSender := calldataload(68)  // Адрес оригинального отправителя
            }

            // Логика проверки: например, если перевод превышает определенное значение или идет на подозрительный адрес
            if (false) {
                // Поднимаем тревогу через Forta
                forta.raiseAlert(from);
            }
        }
    }
}
