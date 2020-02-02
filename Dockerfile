FROM php:7.4

# Install various dependencies
RUN apt-get update -yqq
RUN apt-get install -yqq \
    curl \
    git \
    gnupg2 \
    libcurl4-openssl-dev \
    libfreetype6-dev \
    libicu-dev \
    libjpeg62-turbo-dev \
    libldap2-dev \
    libmagickwand-dev \
    libpcre3-dev \
    libpng-dev \
    libssl-dev \
    libtidy-dev \
    libzip-dev \
    pkg-config \
    zlib1g-dev

# Install PHP extensions
RUN pecl config-set php_ini "${PHP_INI_DIR}/php.ini" \
    && docker-php-ext-configure ldap --with-libdir=lib/x86_64-linux-gnu \
    && docker-php-ext-install -j$(nproc) \
        calendar \
        curl \
        gd \
        gettext \
        intl \
        ldap \
        opcache \
        tidy \
        zip \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Install composer
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# Install node.js & gulp
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash \
    && apt-get install -y nodejs \
    && npm install -g gulp-cli

# Install mssql driver
RUN curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -; \
    curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list; \
    apt-get update -yqq; \
    ACCEPT_EULA=Y apt-get install -yqq msodbcsql17 unixodbc-dev; \
    ACCEPT_EULA=Y pecl install pdo_sqlsrv; \
    docker-php-ext-enable pdo_sqlsrv
