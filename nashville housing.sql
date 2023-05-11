/*
Cleaning Data in SQL
*/

Select *
From [portfolio project]..[NashvilleHousing]

-- Standardize Date Formate

Select SaleDateConverted, CONVERT(Date,SaleDate)
From [portfolio project]..[NashvilleHousing]

UPDATE NashvilleHousing
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE NashvilleHousing
Add SaleDateConverted Date;

Update NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate)
 
-- Populate Property Address data

Select *
From [portfolio project]..[NashvilleHousing]
--where PropertyAddress is null
order by ParcelID


Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [portfolio project]..[NashvilleHousing] a
JOIN [portfolio project]..[NashvilleHousing] b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [portfolio project]..[NashvilleHousing] a
JOIN [portfolio project]..[NashvilleHousing] b
     on a.ParcelID = b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From [portfolio project]..[NashvilleHousing]

SELECT 
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1) as Address
,SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress)) as Address
From [portfolio project]..[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add PropertySplitAddress Nvarchar(255);

Update NashvilleHousing
SET PropertySplitAddress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress) -1)

ALTER TABLE NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1, LEN(PropertyAddress))

SELECT OwnerAddress
From [portfolio project]..[NashvilleHousing]

SELECT 
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)
From [portfolio project]..[NashvilleHousing]

ALTER TABLE NashvilleHousing
Add OwnerSplitAddress Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),3)

ALTER TABLE NashvilleHousing
Add OwnerSplitCity Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),2)

ALTER TABLE NashvilleHousing
Add OwnerSplitState Nvarchar(255);

Update NashvilleHousing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'),1)

SELECT * 
From [portfolio project]..[NashvilleHousing]

-- Change Y and N to Yes and No in "Sold as Vacant" field

SELECT Distinct(SoldAsVacant), Count(SoldAsVacant)
From [portfolio project]..[NashvilleHousing]
Group by SoldAsVacant
Order by 2

SELECT SoldAsVacant,
CASE 
When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END
From [portfolio project]..[NashvilleHousing]

UPDATE NashvilleHousing
SET SoldAsVacant =
CASE 
When SoldAsVacant = 'Y' THEN 'Yes'
When SoldAsVacant = 'N' THEN 'No'
ELSE SoldAsVacant
END

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [portfolio project]..[NashvilleHousing]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From [portfolio project]..[NashvilleHousing]

-- Delete Unused Columns



Select *
From [portfolio project]..[NashvilleHousing]


ALTER TABLE [portfolio project]..[NashvilleHousing]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate